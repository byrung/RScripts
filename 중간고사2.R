# 필요한 라이브러리 로드
library(readxl)
library(ggplot2)
library(gganimate)
library(dplyr)

# 데이터 불러오기
file_path <- "C:/Users/AISW-509-204/Desktop/데이터 분석 실습/temperature.xlsx"
data <- read_excel(file_path, sheet = 1, skip = 1)  # 첫 번째 행 건너뛰기

# 데이터 확인
print(data)

# '년월' 열을 "YYYY/MM" 형식으로 변환
data$년월 <- format(as.Date(data$년월, format = "%Y-%m-%d"), "%Y/%m")

# 막대 그래프 생성: 지역별 월별 평균 기온
ggplot(data, aes(x = 년월, y = `평균기온(℃)`, fill = 년월)) +
  geom_bar(stat = "identity", position = "dodge") +  # 막대 그래프, 지역별로 구분
  labs(title = "지역별 월별 평균 기온", x = "월", y = "평균 기온 (℃)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Blues")  # 색상 팔레트 설정

# 애니메이션 생성: 지역별 월별 평균 기온
anim <- ggplot(data, aes(x = 년월, y = `평균기온(℃)`, fill = 년월)) +
  geom_bar(stat = "identity", position = "dodge") +  # 막대 그래프, 지역별로 구분
  labs(title = "지역별 월별 평균 기온 - {closest_state}", x = "지역", y = "평균 기온 (℃)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Blues") +  # 색상 팔레트 설정
  transition_states(년월) +  # 월별로 상태 전환
  ease_aes('linear')  # 애니메이션 속도 조절

# 애니메이션 실행
animate(anim, width = 800, height = 600, duration = 10, renderer = gifski_renderer(loop = TRUE))
anim_save("서울 월별 기온변화.gif", path="C:/Users/AISW-509-204/Pictures")
