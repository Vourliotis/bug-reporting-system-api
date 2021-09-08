# Bug Reporting System API

A RESTful API written with Ruby on Rails for my [bug-reporting-system](https://github.com/Vourliotis/bug-reporting-system) app. It features json serialization using the [JSON:API](https://github.com/json-api/json-api) gem, authentication with Json Web Tokens (JWT), pagination using the [Kaminari](https://github.com/kaminari/kaminari) gem and multiple query search parameters.

## Available Endpoints

| HTTP Verbs | Paths                                                                                          | Description                                    |
| ---------- | ---------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| GET        | /users **or** /bugs                                                                            | Displays all the users or bugs.                |
| POST       | /users **or** /bugs                                                                            | Creates a new user or bug.                     |
| PUT        | /users/:id **or** /bugs/:id                                                                    | Updates a user or a bug using its id.          |
| DELETE     | /users/:id **or** /bugs/:id                                                                    | Deletes a user or a bug using its id.          |
| GET        | /bugs?title=bug&priority=minor&status=done&reporter=admin&page=1&size=2&sorted=created_at,desc | Different parameters that can be used on bugs. |
