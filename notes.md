## About the project. 

### rplaywright
- The rplaywright package serves as a bridge (wrapper) between R and the Node.js [Playwright library](https://playwright.dev/). Playwright API is currently available on many languages: TypeScript, JavaScript, Python, .NET, Java.
   - no R support at the moment --> inspires me to create one.
- It enables seamless interaction with Playwright functionalities within the R environment. 
- It empowers users to perform web testing and automation tasks efficiently by providing a comprehensive set of tools and functions.
- While currently under development, rplaywright is actively being updated to encompass the full range of Playwright's functionalities.

### playwright pros:
1. **Faster** execution speed, especially for complex tests (compared to [Selenium](https://www.selenium.dev/) or [Puppeteer])(https://www.npmjs.com/package/puppeteer). 
2. Built-in features like **auto-waiting** and recording
   
   a. can handle **lazy-loaded** page

   b. **infinity loading**  --> Keep scrolling until it reaches the bottom of the page.
4. Web-first assertions. Playwright assertions are explicitly **created for the dynamic web**. Checks are automatically retried until the necessary conditions are met.
5. Effortless **Web Automation**: Automate repetitive tasks like web scraping, testing, and end-to-end workflows directly from R.
6. Enhanced **Testing**: Simplify web testing processes and streamline quality assurance within your R projects.
7. Increased **Efficiency**: Focus on analysis and insights, not tedious web interactions.

### how it works:
1. spawn NodeJS server (created using [Fastify](https://fastify.dev/), a web framework for NodeJS) that will serve APIs that will call playwright functions. Example of the APIs: <br />
   a. **page/new** --> call playwright function: `context.newPage()`. <br />
   b. **page/screenshot** --> call playwright function: `page.screenshot(path)`
   
   ```
   instance.post(
    "/screenshot",
    /**
     * @param {FastifyRequest<{ Body: PageScreenshotRequestBody }>} request
     * @param {FastifyReply<{ReplyType : PageScreenshotResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page) {
        const buffer = await page.screenshot({
          path: request.body.path || undefined,
        });
        const base64_image = buffer.toString("base64");

        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
          base64_image: `data:image/png;base64,${base64_image}`,
        });
      }
    });
  
   ```


3. R will call these APIs using [httr package](https://www.rdocumentation.org/packages/httr/versions/1.4.7).
4. Create functions to wrap the functionalities in step no. 2 so that user does not have to understand `httr`. 
For example:
   
```
rplaywright_page_screenshot <- function(
    page, path = NULL
){
  path = R.utils::getAbsolutePath(path)
  resp <- httr::POST(paste0('http://localhost:3000/page/screenshot'), body = list(page_id = page$page_id, path = path), encode = "json", httr::accept_json())
  httr::content(resp)
}
```

### Initial target and current progress:
**can be used for crawling and scraping**
1. Implement most crucial APIs from https://playwright.dev/docs/api/class-browser
2. Implement most crucial APIs from https://playwright.dev/docs/api/class-page.
3. Implement most crucial APIs from https://playwright.dev/docs/api/class-browsercontext

**current progress:** [https://github.com/erikaris/rplaywright/blob/main/R/infra.R](https://github.com/erikaris/rplaywright/blob/main/R/infra.R)


### Next target:
-The package will be designed to be compatible with other popular R packages such as ggplot2, dplyr, and tidyr. --> collected scraped and crawled data can be directly consumed by ggplot2, dplyr, tidyr. 
- The collected data is in json format --> convert into r dataframe. 

### why rplaywright (background story). 
#### background story
I currently work on a project about understanding Micro, Small, and Medium Enterprises (MSMEs) activities in Indonesia through social media data. While working on this project, I worked extensively with a NodeJS library named Playwright. Thus, I want to propose the development of an R package, which I named "rplaywright".
