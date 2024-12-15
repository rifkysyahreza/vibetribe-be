package com.vibetribe.backend.infrastructure.usecase.review.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewRequestDTO {

    @NotNull
    private Long eventId;

    @Min(1)
    @Max(5)
    private Integer rating;

    @NotBlank
    private String review;
}
