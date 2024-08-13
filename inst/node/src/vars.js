const { isObject, camelCase } = require("lodash");

/** @type {{ [key: string]: VarBrowsers }} */
exports.browsers = {};
/** @type {{ [key: string]: VarContexts }} */
exports.contexts = {};
/** @type {{ [key: string]: VarPages }} */
exports.pages = {};
/** @type {{ [key: string]: VarLocators }} */
exports.locators = {};
/** @type {{ [key: string]: VarResponses }} */
exports.responses = {};

exports.objs = {};

const camelCaseRecursive = (data) => {
  if (Array.isArray(data)) return data.map((rec) => camelCaseRecursive(rec));
  if (isObject(data))
    return Object.keys(data).reduce(
      (obj, key) => ({
        ...obj,
        [camelCase(key)]: camelCaseRecursive(data[key]),
      }),
      {}
    );
  return data;
};
exports.camelCaseRecursive = camelCaseRecursive
