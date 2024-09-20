#4장 그래프
#막대그래프

library(ggplot2)
# 데이터 지정(데이터프레임)
dept=c("영업1팀", "영업2팀", "영업3팀")
sales=c(12,7,8)
df1= data.frame(부서=dept, 매출=sales, 분기 ="1분기")
df1

#막대 그래프(1. 그래프의 데이터 초기화, 2. 그래프모양, 3. 제목과 라벨 설정)
ggplot(data = df1, aes(x=부서, y=매출)) +
  geom_bar(stat="identity") +
  labs(title="부서별 영업실적")

# 각 부서별 매출건수
ggplot(data = df1, aes(x=부서)) +
  geom_bar(stat="count") +
  labs(title="부서별 영업실적", x="부서명", y="매출 건 수")

# 막대에 자동색 지정
ggplot(data = df1, aes(x=부서, y=매출, fill = 부서)) +
  geom_bar(stat="identity") +
  labs(title="부서별 영업실적", x="부서명", y="매출(억원)")

# 자동지정되는 색상 확인
install.packages("scales")
library(scales)
hex = hue_pal()(5)
show_col(hex)

#막대에 동일한 채우기 및 테두리선 색상 지정
ggplot(df1, aes(x=부서, y=매출))+
  geom_bar(stat="identity", fill="gold", color="black") +
  labs(title="부서별 영업실적", x="부서명", y="매출(억원")

#막대에 동일한 채우기 및 테두리선 색상 지정
ggplot(df1, aes(x=부서, y=매출))+
  geom_bar(stat="identity", fill=c("tomato", "gold", "purple"), color="black")+
  labs(title="부서별 영업실적", x="부서명", y="매출(억원")

# 막대에 레인보우 색상 중 눈에 잘 띄는 색상으로 자동 변경
ggplot(df1, aes(x=부서, y=매출))+
  geom_bar(stat="identity", fill=rainbow(3), color="black")+
  labs(title="부서별 영업실적", x="부서명", y="매출(억원")

# gdRdriver, RColorBrewer 색상팔레트를 제공하는 두가지 패키지

# gdRdriver 패키지의 팔레트
x = rep(1,12)
pie(x, Tables=seq(1,12), col=rainbow(12))
pie(x, Tables=seq(1,12), col=heat.colors(12))
pie(x, Tables=seq(1,12), col=terrain.colors(12))
pie(x, Tables=seq(1,12), col=topo.colors(12))
pie(x, Tables=seq(1,12), col=cm.colors(12))

# 2. RColorBrewer 패키지의 팔레트
install.packages("RColorBrewer")
library(RColorBrewer)
display.brewer.all()

# 1분기, 2분기의 막대그래프

# 2분기데이터를 데이터프레임에 저장
dept = c("영업1팀", "영업2팀", "영업3팀")
sales= c(10,8,5)
df2 = data.frame(부서 = dept, 매출 = sales, 분기="2분기")

#1분기와 2분기 데이터를 행으로 연결해서 하나의 데이터프레임에 저장
df = rbind(df1, df2)
df

# 부서별 연기별 막대그래프
ggplot(df, aes(x=부서, y=매출, fill=분기))+
  geom_bar(stat = "identity")

#부서별 분기별 막대그래프 작성
#조건1. 3분기 실적을 추가
#조건2.gdRdriver 패키지의 팔레트에 있는 색상을 막대에 설정
#조건3. 그래프 제목: 부서별 분기별 영업실적, x축제목 : 부서명, y축 제목 : 영업매출(억원)
dept = c("영업1팀", "영업2팀", "영업3팀")
sales= c(10,8,5)
df3 = data.frame(부서 = dept, 매출 = sales, 분기="3분기")
df = rbind(df1, df2, df3)
df

ggplot(data = df, aes(x=부서, y=매출))+
  geom_bar(stat="identity", fill=rainbow(9), color="black")+
  labs(title="부서별 영업실적", x="부서명", y="매출(억원")

ggplot(data = df, aes(x=부서, y=매출, fill=분기))+
  geom_bar(stat="identity")+
  scale_fill_manual(values = c("red", "pink","purple"))+
  labs(title="부서별 영업실적", x="부서명", y="매출(억원")

ggplot(data = df, aes(x=부서, y=매출, fill=분기))+
  geom_bar(stat="identity")+
  scale_fill_manual(values = topo.colors(3))+
  labs(title="부서별 영업실적", x="부서명", y="매출(억원")

ggplot(data = df, aes(x=부서, y=매출, fill=분기))+
  geom_bar(stat="identity")+
  scale_fill_manual(values = cm.colors(3))+
  labs(title="부서별 영업실적", x="부서명", y="매출(억원")

# 바로 직전에 실행된 그래프 사진 파일로 저장
ggsave("C:/Temp/graph1.png", width = 10, height = 13, units = "cm")

#================================================
# 선 그래프: 시간에 따라 데이터의 추이를 살필때 사용

# 영업 1팀의 6개월간 데이터를 데이터프레임에 저장
month=c(1,2,3,4,5,6)
sales=c(3,3,5,5,7,4)
df1=data.frame(부서="영업1팀", 월=month, 매출=sales)

# 영업 2팀의 6개월간 데이터를 데이터프레임에 저장
sales=c(2,2,4,8,9,6)
df2=data.frame(부서="영업2팀", 월=month, 매출=sales)

#행으로 df1, df2 연결
df = rbind(df1,df2)
df

# 선형 그래프 그리기
# 영업1팀 데이터만 사용해서
ggplot(data = df1, aes(x=월, y=매출, group = 부서)) +
  geom_line()+
  labs(title= "월별매출")

# 영업2팀 데이터만 사용해서
ggplot(data = df2, aes(x=월, y=매출, group = 부서)) +
  geom_line(color="green", size=2)+
  geom_point(color="red", size=3)
  labs(title= "월별매출")
# 영업1,2팀 데이터 사용  
ggplot(data = df, aes(x=월, y=매출, group = 부서, color=부서)) +
  geom_line(size=2)+
  geom_point(size=3)
  labs(title= "월별매출")
  
ggplot(data = df, aes(x=월, y=매출, group = 부서, color=부서)) +
  geom_line(color=cm.colors(12), size=2)+
  geom_point(color=cm.colrs(12), size=3)
  labs(title= "월별매출")
  
#==============================
#산포도: 점으로 데이터의 변화를 확인
  
ggplot(data = women, aes(x=height, y=weight))+
  geom_point()+
  labs(title="미국 30-39세 여성의 키와 몸무게의 상관관계", x="키(inch)", y="체중(pound")
  
#점의 모양, 색상, 크기 설정
ggplot(data=women, aes(x=height, y=weight))+
  geom_point(shape = 15, color="tomato", size=2)+
  labs(title="미국 30-39세 여성의 키와 몸무게의 상관관계", x="키(inch)", y="체중(pound")