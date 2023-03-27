const createValidator = (schema) => (data) => {
    const { error, value } = schema.validate(data, { abortEarly: false });
    if (error) {
        const validationError = new Error(`${error.message}`);
        validationError.name = "ValidationError";
        throw validationError;
    } else {
        return value;
    }
};
module.exports = createValidator;
