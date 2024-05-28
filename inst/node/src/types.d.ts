type VarBrowsers = {
  browser: import('playwright').Browser
}

type VarContexts = {
  browser_id: string
  context: import('playwright').BrowserContext
}

type VarPages = {
  context_id: string
  page: import('playwright').Page
}

type VarLocators = {
  page_id: string
  locator: import('playwright').Locator
}

type VarResponses = {
  locator_id: string
  response: import('playwright').Response
}



type LaunchBrowserRequestBody = {
  type: 'chromium' | 'firefox' | 'webkit'
}
exports.LaunchBrowserRequestBody = LaunchBrowserRequestBody

type LaunchBrowserResponse = {
  browser_id: string,
  error?: boolean
  message?: string
}
exports.LaunchBrowserResponse = LaunchBrowserResponse

type CloseBrowserRequestBody = {
  browser_id: string,
}
exports.CloseBrowserRequestBody = CloseBrowserRequestBody

type CloseBrowserResponse = {
  browser_id: string,
}
exports.CloseBrowserResponse = CloseBrowserResponse

type NewContextRequestBody = import('playwright').BrowserContextOptions & {
  browser_id: string,
}

type NewContextResponse = {
  browser_id: string,
  context_id: string,
}

type CloseContextRequestBody = {
  context_id: string,
}

type CloseContextResponse = {
  browser_id: string,
  context_id: string,
}

type NewPageRequestBody = {
  context_id: string,
  url?: string,
  content?: string,
  async?: boolean,
}

type BasePageResponse = {
  browser_id: string,
  context_id: string,
  page_id: string,
}

type NewPageResponse = BasePageResponse

type ClosePageRequestBody = {
  page_id: string,
}

type ClosePageResponse = BasePageResponse

type PageGotoRequestBody = {
  page_id: string,
  url: string,
  async: boolean,
}

type PageGotoResponse = BasePageResponse

type PageSetContentRequestBody = {
  page_id: string,
  content: string,
}

type PageSetContentResponse = BasePageResponse

type PageScreenshotRequestBody = {
  page_id: string,
  path?: string,
}

type PageScreenshotResponse = BasePageResponse & {
  base64_image: string,
}

type LocationAction = {
  fill: [
    value: string,
    options?: {
      force?: boolean | undefined;
      noWaitAfter?: boolean | undefined;
      timeout?: number | undefined;
    }
  ]
}

type PageGetByLabelRequestBody = {
  page_id: string,
  text: string | RegExp,
  options?: {
    exact?: boolean | undefined
  } | undefined,
  actions?: LocationAction[]
}

type PageGetByLabelResponse = BasePageResponse

type PageGetByRoleRequestBody = {
  page_id: string,
  role: "alert" | "alertdialog" | "application" | "article" | "banner" | "blockquote" | "button" | "caption" | "cell" | "checkbox" | "code" | "columnheader" | "combobox" | "complementary" | "contentinfo" | "definition" | "deletion" | "dialog" | "directory" | "document" | "emphasis" | "feed" | "figure" | "form" | "generic" | "grid" | "gridcell" | "group" | "heading" | "img" | "insertion" | "link" | "list" | "listbox" | "listitem" | "log" | "main" | "marquee" | "math" | "meter" | "menu" | "menubar" | "menuitem" | "menuitemcheckbox" | "menuitemradio" | "navigation" | "none" | "note" | "option" | "paragraph" | "presentation" | "progressbar" | "radio" | "radiogroup" | "region" | "row" | "rowgroup" | "rowheader" | "scrollbar" | "search" | "searchbox" | "separator" | "slider" | "spinbutton" | "status" | "strong" | "subscript" | "superscript" | "switch" | "tab" | "table" | "tablist" | "tabpanel" | "term" | "textbox" | "time" | "timer" | "toolbar" | "tooltip" | "tree" | "treegrid" | "treeitem",
  options?: {
    checked?: boolean,
    disabled?: boolean,
    exact?: boolean,
    expanded?: boolean,
    includeHidden?: boolean,
    level?: number,
    name?: string | RegExp,
    pressed?: boolean,
    selected?: boolean,
  } | undefined,
  actions?: LocationAction[]
}

type PageGetByRoleResponse = BasePageResponse

type PageWaitForTimeoutRequestBody = {
  page_id: string,
  timeout: number
}

type PageWaitForTimeoutResponse = BasePageResponse

type PageWaitForResponseFilter = {
  url?: string|RegExp
}

type PageWaitForResponseFilterAnd = {
  and?: PageWaitForResponseFilter[]
}

type PageWaitForResponseFilterOr = {
  or?: PageWaitForResponseFilter[]
}

type PageWaitForResponseRequestBody = {
  page_id: string,
  timeout: number,
  // predicate: (resp: import('playwright').Response) => boolean,
  filter: (PageWaitForResponseFilterAnd | PageWaitForResponseFilterOr),
}

type PageWaitForResponseResponse = BasePageResponse & {
  success: boolean,
  message: string,
}

type PageScrollDownRequestBody = {
  page_id: string,
  to: number
}

type PageScrollDownResponse = BasePageResponse

type PageScrollToBottomRequestBody = {
  page_id: string,
}

type PageScrollToBottomResponse = BasePageResponse

module.exports = {
  VarBrowsers,
  VarContexts,
  VarPages,

  NewContextRequestBody,
  NewContextResponse,
  CloseContextRequestBody,
  CloseContextResponse,

  NewPageRequestBody,
  NewPageResponse,
  ClosePageRequestBody,
  ClosePageResponse,
  PageGotoRequestBody,
  PageGotoResponse,
  PageSetContentRequestBody,
  PageSetContentResponse,
  PageScreenshotRequestBody,
  PageScreenshotResponse,
}