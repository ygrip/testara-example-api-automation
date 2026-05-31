package io.github.ygrip.example.data;

import java.util.List;

import io.github.ygrip.example.model.Jokes;
import io.github.ygrip.testara.core.model.DefaultData;
import io.github.ygrip.testara.core.model.ResponseData;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
@ResponseData
public class AutomationResponseData extends DefaultData {
  private List<Jokes> jokesList;
}
