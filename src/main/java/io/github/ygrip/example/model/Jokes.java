package io.github.ygrip.example.model;

import lombok.Data;

@Data
public class Jokes {
  private String type;
  private String setup;
  private String punchline;
  private Long id;
}
