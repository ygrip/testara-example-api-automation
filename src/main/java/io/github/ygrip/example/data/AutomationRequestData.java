package io.github.ygrip.example.data;

import io.github.ygrip.testara.core.model.DefaultData;
import io.github.ygrip.testara.core.model.RequestData;
import io.github.ygrip.testara.core.model.ResponseData;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
@RequestData
public class AutomationRequestData extends DefaultData {
  private Integer size;
}
