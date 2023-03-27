module.exports = {
    SchemaValidateMiddleWare: async (req, res, next, schema, type) => {
      try {
        let data;
        if (type === "query") {
          data = await schema.validateAsync(req.query, { abortEarly: false });
        } else if (type === "body") {
          data = await schema.validateAsync(req.body, { abortEarly: false });
        } else if (type === "params") {
          data = await schema.validateAsync(req.params, { abortEarly: false });
        }
        console.log(data);
        if (data) {
          next();
        }
      } catch (error) {
        res.status(400).json(error.details.map((err) => err.message));
      }
    },
  };
  