@TestApiFeature @ApiTest
Feature: Test calling api

  @TestData
  Scenario: Test to construct request data and validate schema
    Given [testara] using service with alias jokes
    And [testara] prepare request data var with value
      | firstName | lastName | membershipNumber   |
      | Yunaz     | Gilang   | random(10,NUMERIC) |
    And [testara] prepare request data baru from template "Request" with value
      | userId           | variables         |
      | Chaotic things   | request($['var']) |
      | Chaotic things 2 | request($['var']) |
    And [testara] prepare body request with value "request($['baru'])"
    Then [testara] do these validations
      | actual                                                 | validation       | expectation                    |
      | request($['baru'])                                     | NOT_EMPTY        | true                           |
      | request($['baru'][*]['variables']['firstName'])        | CONTAINS         | request($['var']['firstName']) |
      | request($['baru'][*]['variables']['lastName'])         | NOT_CONTAINS     | request($['var']['firstName']) |
      | request($['baru'][*]['variables']['lastName'])         | MATCH_PATTERN    | ^[A-Za-z]+$                    |
      | request($['baru'][*]['variables']['membershipNumber']) | MATCH_PATTERN    | ^\d{10}$                       |
      | request($['baru'])                                     | ALL_MATCH_SCHEMA | RequestSchema                  |

  @TestData
  Scenario: Test reset the data
    Given [testara] using service with alias testara
    And [testara] prepare request data var with value
      | firstName | lastName | membershipNumber   |
      | Yunaz     | Gilang   | random(10,NUMERIC) |
    And [testara] prepare request data baru from template "Request" with value
      | userId           | variables         |
      | Chaotic things   | request($['var']) |
      | Chaotic things 2 | request($['var']) |
    And [testara] prepare body request with value "request($['baru'])"
    Then [testara] do these validations
      | actual                                                 | validation       | expectation                    |
      | request($['baru'])                                     | NOT_EMPTY        | true                           |
      | request($['baru'][*]['variables']['firstName'])        | CONTAINS         | request($['var']['firstName']) |
      | request($['baru'][*]['variables']['lastName'])         | NOT_CONTAINS     | request($['var']['firstName']) |
      | request($['baru'][*]['variables']['lastName'])         | MATCH_PATTERN    | ^[A-Za-z]+$                    |
      | request($['baru'][*]['variables']['membershipNumber']) | MATCH_PATTERN    | ^\d{10}$                       |
      | request($['baru'])                                     | ALL_MATCH_SCHEMA | RequestSchema                  |
    And [testara] reset request data "var"
    Then [testara] do these validations
      | actual            | validation | expectation |
      | request($['var']) | NOT_EMPTY  | false       |
    And [testara] reset request data "$['baru'][*]['variables']['firstName']"
    Then [testara] do these validations
      | actual                                          | validation | expectation |
      | request($['baru'])                              | NOT_EMPTY  | true        |
      | request($['baru'][*]['variables']['firstName']) | ALL_EQUAL  | request()   |
    And [testara] reset request data
    Then [testara] do these validations
      | actual             | validation | expectation |
      | request($['baru']) | NOT_EMPTY  | false       |

  @TestUndefinedApi
  Scenario: Test get undefined API
    Given API using service with alias test
    When API try GET request to "https://jsonplaceholder.typicode.com/todos/1"
    Then API assign previous response data to data

  @TestWait
  Scenario: Test wait
    Given API using service with alias test
    When API try GET request to "https://jsonplaceholder.typicode.com/todos/1"
    And API wait for 3 seconds
    Then API assign previous response data to data

  @TestDefinedApi
  Scenario: Test get random jokes from jokes api
    Given API using service with alias jokes
    And API prepare request data size with value "number(1,5)"
    And API prepare pathParam for size with value "request($['size'])"
    When API try GET request to "random/{size}"
    Then API assign previous response data to jokesList
    And API do these validations
      | actual                           | validation | expectation        |
      | response($['jokesList'])         | NOT_EMPTY  | true               |
      | sizeof(response($['jokesList'])) | EQUAL      | request($['size']) |
    