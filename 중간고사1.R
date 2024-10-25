install.packages("readxl")
library("readxl")
library("dplyr")
library("gganimate")
library("ggplot2")
library("gifski")

# 1번 문제
# 엑셀 파일 불러오기
file_path <- "C:/Users/AISW-509-204/Desktop/데이터 분석 실습/sidoAirInfo.xls"
data <- read_excel(file_path, sheet=1)
print(colnames(data)) 

# 데이터 처리: 지역과 시간평균 열 선택 및 숫자로 변환
df1 <- data %>%
  select(지역, 시간평균) %>%  # '지역'과 '시간평균' 열 선택
  mutate(시간평균 = as.numeric(gsub("[^0-9.]", "", 시간평균))) %>% # 숫자형으로 변환
  filter(!is.na(시간평균))
  # 결과 확인
  print(df1)

# 시간 평균 미세먼지 농도
# 막대그래프 애니메이션 그리기
anim <- ggplot(df1, aes(x=지역, y=시간평균, fill=지역)) +
  geom_bar(stat="identity") +
  labs(title = "지역별 시간 평균 미세먼지 농도", y = "미세먼지 농도") +
  transition_reveal(시간평균)  # 지역을 기준으로 애니메이션 진행

# 애니메이션 효과 설정 및 실행
animate(anim, width=500, height=400, duration=3, renderer=gifski_renderer(loop=5))

# 애니메이션을 GIF 형식으로 저장
anim_save("지역별_시간_평균_미세먼지_농도.gif", path="C:/Users/AISW-509-204/Pictures")

# 2번 문제
# 엑셀 파일 불러오기
file_path <- "C:/Users/AISW-509-204/Desktop/데이터 분석 실습/sidoAirInfoWeek.xls"
data <- read_excel(file_path, sheet=1)
print(colnames(data)) 

# 데이터 전처리
install.packages("tidyr")
library("tidyr")

data_long <- data %>%
  pivot_longer(cols = -지역, names_to = "날짜", values_to = "미세먼지농도") %>%
  mutate(날짜 = as.Date(날짜), 
         미세먼지농도 = as.numeric(미세먼지농도)) # 미세먼지 농도를 정수로 변환

# 애니메이션 생성
anim <- ggplot(data_long, aes(x = 날짜, y = 미세먼지농도, group = 지역, color = 지역)) +
  geom_line(size = 2, alpha = 0.5) +  # 선의 두께를 2로 설정
  geom_point(size = 4) +  # 점의 크기를 4로, 투명도를 50%로 설정
  labs(title = "지역별 일주일간 미세먼지 농도", x = "날짜", y = "미세먼지 농도") +
  transition_reveal(날짜) +
  theme_minimal()

# 애니메이션 실행
animate(anim, width = 800, height = 600, duration = 10, renderer = gifski_renderer(loop = FALSE))
anim_save("지역별 일주일간 미세먼지 농도.gif", path="C:/Users/AISW-509-204/Pictures")