class Browser

    "Open browser": (params, respond) ->
        page = do require("webpage").create
        page.viewportSize = width: 1024, height: 768
        page.onAlert = (msg) -> robot.debug msg
        page.onConsoleMessage = (msg) -> robot.debug msg

        ###
        prevent new actions before the current page has been loaded;
        the magic here is to store the last resource request before
        onLoadStarted and follow that request to be completed
        ###
        page.robotIsLoading = false
        page.robotIsLoadingURL = null
        page.onLoadStarted = -> page.robotIsLoading = true
        page.onResourceRequested = (request) ->
            if not page.robotIsLoading
                page.robotIsLoadingURL = request.url
        page.onResourceReceived = (request) ->
            if page.robotIsLoading and request.url == page.robotIsLoadingURL
                page.robotIsLoading = false

        ###
        define generic query-method to be available in eval
        ###
        queryAll = (element, query) ->
            if /css=(.*)/.test query
                selector = query.match(/css=(.*)/)[1]
                element.querySelectorAll(selector) or []
            else if /id=(.*)/.test query
                selector = query.match(/id=(.*)/)[1]
                result = document.getElementById selector
                result and [result] or []
            else
                selector = query
                result = document.getElementById selector
                result and [result] or []
        ###
        define custom page.evaluate with support for params
        http://code.google.com/p/phantomjs/issues/detail?id=132#c44
        ###
        page.eval = (func) ->  # 'evaluate with parameters'
            # Prevent "onbeforeunload" (not supported by phantomjs)
            page.evaluate -> window.onbeforeunload = ->  # I'm dumb

            # Exit quicly when the browser is still loading the html
            if page.robotIsLoading
                throw "Browser was busy (loading in progress)."

            # Evaluate with parameters
            str = "function() { queryAll = #{do queryAll.toString};"
            str += "return (#{do func.toString})("
            for arg in [].slice.call arguments, 1
                str += (/object|string/.test typeof arg)\
                    and "JSON.parse(#{JSON.stringify(JSON.stringify(arg))}),"\
                    or arg + ","
            str = str.replace /,$/, "); }"
            page.evaluate str

        @page = page
        respond status: "PASS"

    "Maximize browser window": (params, respond) ->
        respond status: "PASS"

    "Close browser": (params, respond) ->
        respond status: "PASS"

    "Go to": (params, respond) ->
        url = params[1][0]
        has_been_completed = false

        if @page.robotIsLoading
            respond status: "FAIL",\
                    error: "Browser was busy (loading in progress)."
        else
            @page.open url, (status) =>
                if not has_been_completed
                    has_been_completed = true
                    respond status: "PASS"
