library(rvest)

url = "https://www.airkorea.or.kr/web/sidoQualityCompare?itemCode=10008&pMENU_NO=102"
html = read_html(url)
html

titles = html_nodes(html, "#sidoTable_thead") %>%
  html_text()

titles

# 특수 문자열들을 ""(empty string) 대체
titles = gsub("\r|\n|\t", "", titles)
titles


# 8장 공공 데이터 활용
# 공공데이터 활용신청한 url

api = "https://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst?serviceKey=aeIst%2BxQr69nc2jnUv0MYbI3MQ6QO6z4IvCBqwHEkFOVQdlLdChDJdUv88gae5Nfmv%2FTMcXQae7lx3b%2F0eX9sw%3D%3D&returnType=xml&numOfRows=10&pageNo=1&itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH"

# %3D라는 일반 인증키 사용
api_key = "aeIst%2BxQr69nc2jnUv0MYbI3MQ6QO6z4IvCBqwHEkFOVQdlLdChDJdUv88gae5Nfmv%2FTMcXQae7lx3b%2F0eX9sw%3D%3D"

returnType = "XML"
numOfRows = 10
pageNo = 1
itemCode = "PM10"
dataGubun = "HOUR"
searchCondition = "MONTH"

url = paste0(api, "?servicekey=", api_key, "&returnType=", returnType, "&numOfRows=", numOfRows, "&pageNo=", pageNo, "&itemCode=", itemCode, "&dataGubun=", dataGubun, "&searchCondition=", searchCondition)
url

url2 = "https://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst?serviceKey=aeIst%2BxQr69nc2jnUv0MYbI3MQ6QO6z4IvCBqwHEkFOVQdlLdChDJdUv88gae5Nfmv%2FTMcXQae7lx3b%2F0eX9sw%3D%3D&returnType=xml&numOfRows=10&pageNo=1&itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH?servicekey=aeIst%2BxQr69nc2jnUv0MYbI3MQ6QO6z4IvCBqwHEkFOVQdlLdChDJdUv88gae5Nfmv%2FTMcXQae7lx3b%2F0eX9sw%3D%3D&returnType=XML&numOfRows=10&pageNo=1&itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH"

install.packages("XML")
install.packages("httr")
install.packages("xml2")
library(XML)
library(httr)
library(xml2)

response = GET(url)
content = content(response, "text")


xmlFile = xmlParse(content, asText=TRUE)
xmlFile

# XML => 데이터프레임으로 변환
df = xmlToDataFrame(getNodeSet(xmlFile, "//items/item"))
df


library(ggplot2)

# 미세먼지 시간별 농도 그래프
ggplot(data = df, aes(x=dataTime, y=seoul)) + 
  geom_bar(stat = "identity", fill = "orange") + 
  theme(axis.text.x = element_text(angle=90)) + 
  labs(title = "시간대별 서울지역의 미세먼지 농도 변화", x="측정일시", y = "미세먼지농도(PM10")

# 지역별 미세먼지 농도의 지도 분포
# 미세먼지 농도에 대한 데이터프레임 확인

df

# df에서 필요한 데이터만 추출
# 제공되는 미세먼지 데이터 중 마지막 시간의 데이터가 1행이고, 지역이 연속적이지 않기 때문에 아래와 같은 데이터추출이 필요
pm = df[1, c(1:16, 19)]
pm

# 지역별 미세먼지 데이터프레임의 행과 열을 바꾸기
pm.region = t(pm)
pm.region

# 행렬데이터를 데이터프레임으로 변환
df.region = as.data.frame(pm.region)
df.region

# 1로 설정된 컬럼이름을 PM10 컬럼명으로 변경
colnames(df.region) = "PM10"
df.region

###########################################################

url2 = "https://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst?serviceKey=aeIst%2BxQr69nc2jnUv0MYbI3MQ6QO6z4IvCBqwHEkFOVQdlLdChDJdUv88gae5Nfmv%2FTMcXQae7lx3b%2F0eX9sw%3D%3D&returnType=xml&numOfRows=10&pageNo=1&itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH"

install.packages("XML")
install.packages("httr")
install.packages("xml2")
library(XML)
library(httr)
library(xml2)

response = GET(url2)
content = content(response, "text")
content

xmlFile = xmlParse(content, asText=TRUE)
xmlFile


# XML => 데이터프레임으로 변환
df = xmlToDataFrame(getNodeSet(xmlFile, "//items/item"))
df

# df에서 필요한 데이터만 추출
# 제공되는 미세먼지 데이터 중 마지막 시간의 데이터가 1행이고, 지역이 연속적이지 않기 때문에 아래와 같은 데이터추출이 필요
pm = df[1, c(1:16, 19)]
pm

# 지역별 미세먼지 데이터프레임의 행과 열을 바꾸기
pm.region = t(pm)
pm.region

# 행렬데이터를 데이터프레임으로 변환
df.region = as.data.frame(pm.region)
df.region

# 1로 설정된 컬럼이름을 PM10 컬럼명으로 변경
colnames(df.region) = "PM10"
df.region

# df.region에 컬럼추가(컬럼명 : name, 값 : 한글자명)

df.region$NAME = c("대구광역시", "충청남도", "인천광역시", "대전광역시", "경상북도", 
                    "세종특별자치시", "광주광역시", "전라북도", "강원도", 
                    "울산광역시", "전라남도", "서울특별시", "부산광역시", 
                    "제주특별자치도", "충청북도", "경상남도", "경기도")
df.region

#행정경계 데이터셋을 사용한 지도 시각화
install.packages("sf")
install.packages("dplyr")
library(sf)
library(dplyr)

#행정경계 데이터셋(shape[.shpe]파일) 읽어오기
map = st_read("C:/Users/AISW-509-204/Desktop/데이터 분석 실습/행정경계데이터셋/Z_NGII_N3A_G0010000.shp" , options = "ENCODING=EUC-KR")
map

# wgs84 좌표계
crs_wgs84=st_crs(4326)

# WGS84좌표계로 map을 변환

map_sf = st_transform(map, crs_wgs84)
map_sf

# sf객체를 데이터프레임으로 변환
df_map = st_as_sf(map_sf)
df_map

# 지형정보 확인
st_geometry(map)

# df_map 데이터프레임의 구조 확인
str(df_map)

#그룹화 변수 확인
table(df_map$id)
names(str(df_map))

# 경도와 위도를 추출해서 저장
# 현재 df_map이 유효한 데이터임을 증명
df_map = st_make_valid(df_map)
df_map

# id(UFID)를 기준으로 그룹화
longlat = df_map %>% group_by(UFID)%>%
                summarise(geometry = st_centroid(st_union(geometry)), .groups = "drop") %>%
                 mutate(long=st_coordinates(geometry)[,1],
                        lat=st_coordinates(geometry)[,2]
                 )
longlat


#경도위도 데이터셋의 결과를 데이터프레임으로 변환
longlat_df = longlat %>% st_drop_geometry() %>% as.data.frame()

longlat_df
str(longlat_df)
longlat_df
df.region

#공간정보 데이터프레임에서 기하확적 정보를 제거하는 기능
df_map_info = st_drop_geometry(df)
df_map_info

longlat = cbind(longlat, NAME=df_map_info[, 3])
longlat
df.PM10 = merge(x=df.region, y=longlat, by="NAME", all=TRUE)
df.PM10

library(ggplot2)

ggplot() +
  #geom_sf(data=map,
  #        fill="white",
  #        alpha=0.5,
  #        color="black") + 
  geom_polygon(data=total_longlat,
               aes(x=long, y=lat),
               fill="white",
               alpha=0.5,
               color = "black"
               )+
  geom_point(data = df.PM10, aes(x=long, y=lat, size=PM10),
             shape=21, color="black", fill='red', alpha=0.3)+
  theme(legend.position = "none")+
  labs(title="PM10 노동 분포", x="경도", y="위도")
