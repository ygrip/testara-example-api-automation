# Testara Sample API Automation

Sample API automation project built with Java 21, Maven, Cucumber, and the Testara framework. The project demonstrates request/response data binding, reusable templates, JSON schema validation, API calls, and examples for backend integrations such as SQL, MongoDB, Kafka, and file utilities.

## Tech Stack

- Java 21
- Maven
- Testara `2.0.3`
- Cucumber
- JUnit 4 runner
- JUnit 5/Testara engine runner
- Lombok

## Project Structure

```text
.
├── pom.xml
├── src/main/java/io/github/ygrip/example
│   ├── data
│   │   ├── AutomationRequestData.java
│   │   └── AutomationResponseData.java
│   └── model
│       └── Jokes.java
└── src/test
    ├── java/io/github/ygrip/example
    │   ├── Junit4RunnerTests.java
    │   └── Junit5RunnerTests.java
    └── resources
        ├── application.properties
        ├── configuration.properties
        ├── cucumber.properties
        ├── junit-platform.properties
        ├── features
        │   ├── regression/TestFull.feature
        │   └── sanity/TestApi.feature
        ├── schemas/RequestSchema.json
        └── templates/Request.json
```

## What This Project Tests

The active API examples are in `src/test/resources/features/sanity/TestApi.feature`.

- Builds request data using Testara data expressions.
- Creates request body data from `src/test/resources/templates/Request.json`.
- Validates generated request data with `src/test/resources/schemas/RequestSchema.json`.
- Resets request data at object and JSONPath levels.
- Calls `https://jsonplaceholder.typicode.com/todos/1` directly.
- Calls the configured `jokes` API service using `random/{size}`.
- Stores joke API responses into `AutomationResponseData.jokesList`.
- Validates response size against generated request data.

`src/test/resources/features/regression/TestFull.feature` contains broader backend examples for SQL, MongoDB, Kafka, Kafka consumers, and file generation. Those scenarios are currently tagged with `@Ignored`, so they are examples unless the tag filter and required services are configured.

## Data Models

`AutomationRequestData` is registered as Testara request data with `@RequestData` and currently defines:

- `size`

`AutomationResponseData` is registered as Testara response data with `@ResponseData` and currently defines:

- `jokesList`

`Jokes` maps the response from the official joke API:

- `type`
- `setup`
- `punchline`
- `id`

## Configuration

Main runtime configuration lives in `src/test/resources/application.properties`.

Important entries:

- `api.service.jokes.host=https://official-joke-api.appspot.com`
- `api.service.jokes.basePath=/jokes/`
- `api.service.jokes.default_specification=default`
- `spec.api.default.parameter.username=yunaz.ramadhan`
- `spec.api.default.header.Content-Type=application/json`
- `spec.api.default.header.Accept-Language=application/json`

Testara scanner and template/schema locations live in `src/test/resources/configuration.properties`.

```properties
automation.config.template-folder=/src/test/resources/templates/
automation.config.schema-folder=/src/test/resources/schemas/
```

## Test Runners

### JUnit 4

`src/test/java/io/github/ygrip/example/Junit4RunnerTests.java` uses:

- Cucumber JUnit 4 runner
- `TestaraObjectFactory`
- feature path `src/test/resources/features/`
- glue packages `io.github.ygrip.testara` and `io.github.ygrip.example`
- tag filter `(@ApiTest) and not (@Manual or @Deprecated or @Ignored)`

### JUnit 5

`src/test/java/io/github/ygrip/example/Junit5RunnerTests.java` uses Testara's `@TestSuite`.

JUnit Platform and Testara engine settings are configured in `src/test/resources/junit-platform.properties`, including:

- glue packages `io.github.ygrip.testara,io.github.ygrip.example`
- feature path `src/test/resources/features/`
- tag filter `(@Sanity) and not (@Manual or @Deprecated or @Ignored)`
- dynamic parallel execution
- virtual thread execution

Note: the current sanity feature is tagged `@ApiTest`, not `@Sanity`. The project still runs through `mvn test` with the current local setup, but align the tags if you want JUnit Platform filtering to select only sanity scenarios.

## Running Tests

From the project root:

```bash
mvn test
```

This command was verified successfully and runs the current Cucumber/Testara API scenarios.

To run a specific Cucumber tag:

```bash
mvn test -Dcucumber.filter.tags="@TestDefinedApi"
```

The Failsafe `verify` phase is wired in the POM, but it currently needs project configuration fixes before it is a clean default command. The runner package can be overridden like this:

```bash
mvn verify -Dit.test=io.github.ygrip.example.Junit4RunnerTests
```

With the current implementation, that command reaches the custom report phase and then fails because of the report directory mismatch described below.

## Reports

Cucumber output is configured in `src/test/resources/cucumber.properties`:

- HTML: `target/destination/cucumber.html`
- JSON: `target/destination/cucumber.json`
- rerun file: `target/rerun/rerun.txt`

The `junit4` Maven profile also configures `testara-reporter-plugin` to generate a summary report under `target/site/`.

## Known Current Caveats

- `mvn verify` currently fails before running Failsafe tests because the default `it.test` property points to `io.github.ygrip.automation.Junit4RunnerTests`, while the actual class is `io.github.ygrip.example.Junit4RunnerTests`.
- Overriding `it.test` reaches the report phase, but the custom report plugin expects reports in `target/cucumber-reports/` while Cucumber is configured to write JSON to `target/destination/cucumber.json`.
- The `junit5` Maven profile declares `org.junit.platform:junit-platform-console-standalone` without an explicit version, so `mvn verify -Pjunit5` fails during Maven project building.
- `@RTK.md` is referenced by the workspace instructions, but no `RTK.md` file exists in this project tree.

## Adding New API Scenarios

1. Add or update service configuration in `src/test/resources/application.properties`.
2. Add request fields to `AutomationRequestData` when a scenario needs typed request data.
3. Add response fields to `AutomationResponseData` when a scenario needs typed response storage.
4. Add reusable JSON payloads under `src/test/resources/templates/`.
5. Add JSON schemas under `src/test/resources/schemas/`.
6. Add Cucumber scenarios under `src/test/resources/features/`.
7. Tag scenarios so they match the active runner filter.
