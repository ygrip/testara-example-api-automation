package io.github.ygrip.example;

import static io.cucumber.junit.CucumberOptions.SnippetType.CAMELCASE;

import org.junit.runner.RunWith;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import io.github.ygrip.testara.cucumber.factory.TestaraObjectFactory;

//@formatter:off
@RunWith(Cucumber.class)
@CucumberOptions(objectFactory = TestaraObjectFactory.class,
  stepNotifications = true,
  monochrome = true,
  snippets = CAMELCASE,
  features = "src/test/resources/features/",
  //        features = "@target/rerun/rerun.txt",
  glue = {"io.github.ygrip.testara", "io.github.ygrip.example"},
  tags = "(@ApiTest) and not (@Manual or @Deprecated or @Ignored)"
)
public class Junit4RunnerTests {
}
//@formatter:on
