# 로또 번호 추첨 시뮬레이션

# 1. 변수 초기화
set.seed(42)           # 재현성을 위한 랜덤 시드 설정
iteration <- 100      # 로또 추첨 횟수
lotto_numbers <- 1:45  # 로또 번호 범위
draw_count <- numeric(length(lotto_numbers))  # 각 번호의 당첨 횟수 저장

# 2. 로또 번호 추첨
for (i in 1:iteration) {
  draw <- sample(lotto_numbers, 6, replace = FALSE)  # 비복원 추출
  draw_count[draw] <- draw_count[draw] + 1           # 당첨 횟수 누적
}

# 3. 결과 데이터프레임 생성
lotto_results <- data.frame(
  Number = lotto_numbers,
  Frequency = draw_count
)

# 데이터프레임 확인
print(lotto_results)

# 결과 저장 (선택사항)
write.csv(lotto_results, "lotto_results.csv", row.names = FALSE)

# 4. 번호별 당첨 횟수 분포 시각화
library(ggplot2)

ggplot(lotto_results, aes(x = Number, y = Frequency)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(
    title = "번호별 당첨 횟수 분포 그래프",
    x = "Lotto Number",
    y = "Frequency"
  ) +
  theme_minimal()

# 5. 누적 추첨 결과 확인
# 누적 빈도 저장 변수 초기화
cumulative_results <- matrix(0, nrow = iteration, ncol = 45)

# 누적 빈도 계산
for (i in 1:iteration) {
  draw <- sample(lotto_numbers, 6, replace = FALSE)
  cumulative_results[i, draw] <- cumulative_results[i, draw] + 1
  
  if (i > 1) {
    cumulative_results[i, ] <- cumulative_results[i, ] + cumulative_results[i - 1, ]
  }
}

# 누적 빈도를 데이터프레임으로 변환
cumulative_df <- data.frame(
  Iteration = 1:iteration,
  CumulativeMean = rowMeans(cumulative_results)
)

# 6. 누적 결과 시각화
ggplot(cumulative_df, aes(x = Iteration, y = CumulativeMean)) +
  geom_line(color = "blue", size = 1) +
  labs(
    title = "누적 평균 그래프",
    x = "Number of Iterations",
    y = "Cumulative Mean"
  ) +
  theme_minimal()
