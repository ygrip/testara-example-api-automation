@TestFullFeatureBackend @Backend
Feature: Test various backend system

  @TestSql @Ignored
  Scenario: Test execute SQL query
    Given [testara] prepare request data query with value :
    """
    sql(
      db(testing),
      query(
        SELECT COUNT (*) FROM users;
      ))
    """
    When [testara] assign response data dbResponse with value "request($['query'])"
    Then [testara] response data "response($['dbResponse'])" should not be empty

  @TestMongoDb @Ignored
  Scenario: Test execute Mongo query
    Given [testara] prepare request data query with value :
    """
    mongo(
      db(testara),
      collection(parameter),
      find({
        variable : "TESTING"
      }),
      project({
        variable : 1, value : 1, description : 1
      })
    )
    """
    When [testara] assign response data dbResponse with value "request($['query'])"
    Then [testara] response data "response($['dbResponse'])" should not be empty
    Given [testara] prepare request data query with value :
    """
    mongo(
      db(testara),
      collection(parameter),
      find({
        variable : "TESTING"
      }),
      project({
        variable : 1, value : 1, description : 1
      })
    )
    """
    When [testara] assign response data dbResponse with value "request($['query'])"
    Then [testara] response data "response($['dbResponse'])" should not be empty

  @TestKafka @Ignored
  Scenario: Test publish message to kafka
    Given [testara] prepare request data username with value "(automation_,timestamp(),@badak.com)"
    And [testara] prepare request data syncRequest with value
      | logonId                | timestamp   |
      | request($['username']) | timestamp() |
    And [testara] start kafka producer for testara
    When [testara] send batch message to kafka with data
      | topic     | message                   |
      | sync_data | request($['syncRequest']) |
      | sync_data | request($['syncRequest']) |
    Then [testara] stop kafka producer
    Given [testara] start kafka producer for quest
    When [testara] send kafka message to topic "sync_data" with data "request($['syncRequest'])"
    Then [testara] stop kafka producer

  @TestKafka @Ignored
  Scenario: Test publish message with key to kafka
    Given [testara] prepare request data username with value "(automation_,timestamp(),@testara.com)"
    And [testara] prepare request data syncRequest with value
      | logonId                | timestamp   |
      | request($['username']) | timestamp() |
    And [testara] start kafka producer for quest
    When [testara] send batch message to kafka with data
      | topic     | message                   | key             |
      | sync_data | request($['syncRequest']) | dari-automation |
    Then [testara] stop kafka producer
    Given [testara] start kafka producer for quest
    When [testara] send kafka message to topic "recovery_account_granted" with key "dari-automation-2" and data "request($['syncRequest'])"
    Then [testara] stop kafka producer

  @TestKafkaConsumer @Ignored
  Scenario: Test kafka consumer with filter
    Given [testara] start kafka consumer for testara
    When [testara] assign 1 latest records from topic "sync_message" to kafkaResponse and filter by
      | actual | validation | expectation |
      | code   | EQUAL      | order       |
    Then [testara] stop kafka consumer
    And [testara] do these validations
      | actual                                           | validation | expectation |
      | response($['kafkaResponse'])                     | NOT_EMPTY  | true        |
      | response($['kafkaResponse'][*]['value']['code']) | ALL_EQUAL  | order       |

  @TestKafkaConsumer @Ignored
  Scenario: Test kafka consumer with complex filter
    Given [testara] start kafka consumer for testara
    When [testara] assign 1 latest records from topic "sync_message" to kafkaResponse and filter by
      | actual           | validation | expectation |
      | code             | EQUAL      | order       |
      | $.variables.name | NOT_EMPTY  | true        |
    Then [testara] stop kafka consumer
    And [testara] do these validations
      | actual                                                        | validation | expectation |
      | response($['kafkaResponse'])                                  | NOT_EMPTY  | true        |
      | response($['kafkaResponse'][*]['value']['code'])              | ALL_EQUAL  | order       |
      | response($['kafkaResponse'][0]['value']['variables']['name']) | NOT_EMPTY  | true        |

  @TestFile @Ignored
  Scenario: Create various type of file
    When [file] create excel file with name "username" and data
      | username                      | password   |
      | qatesting.yunaz@testara.com   | testing123 |
      | qatesting.testara@testara.com | testing123 |
    And [file] create excel file with name "username-without-header" and without header and data
      | username                      | password   |
      | qatesting.yunaz@testara.com   | testing123 |
      | qatesting.testara@testara.com | testing123 |
    And [file] create json file with name "username-json.json" and data
      | username                      | password   |
      | qatesting.yunaz@testara.com   | testing123 |
      | qatesting.testara@testara.com | testing123 |
    And [file] create csv file with name "username.csv" and delimiter "," and data
      | username                      | password   |
      | qatesting.yunaz@testara.com   | testing123 |
      | qatesting.testara@testara.com | testing123 |
    And [file] update excel file with name "username.xls" with new data
      | row | column | data  |
      | 1   | A      | email |
    And [file] delete file with name "/src/test/resources/username.xls"
    And [file] delete file with name "/src/test/resources/username.csv"
    And [file] delete file with name "/src/test/resources/username-json.json"
    And [file] delete file with name "/src/test/resources/username-without-header.xls"

  @TestBasicMongoStep @Ignored
  Scenario: Test basic mongo query
    Given [x-member] prepare request data query with value
      | key     |
      | TESTING |
    When [mongo] connect to database with name testara
    And [mongo] select collection with name config
    And [mongo] select data with query :
      | query               | sort | project     |
      | request($['query']) | {}   | {"value":1} |
    And [mongo] assign previous database response to dbResponse