install.packages("RCurl")
install.packages("RmecabKo")
install.packages("wordcloud2")

library(RCurl)
library(XML)
library(RmecabKo)
library(wordcloud2)

#형태소분석을 위한 기능 설치
install_mecab("C:/RmecabKo/mecab")

# Naver Opin API에서 뉴스 검색을 위한 요청 주소를 작성
searchUrl = "https://openapi.naver.com/v1/search/news.xml"
Client_ID = "gpI5f544UTPo0sfdjwxq"
Client_Secret = "ijaBBNhdUJ"

# 검색하고자 하는 키워드를 한글이 경우 UTF-8로 인코딩 설정

query = URLencode(iconv("2024년도 인기방송", "UTF-8"))
# 변수에 저장된 url들 하나의 url로 합치기
url = paste(searchUrl, "?query=", query, "&display=20", sep = "")
url

# url을 사용하여 검색한 결과 페이지를 요청하여 반환
doc = getURL(url, httpheader=c('Content-Type'="application/xml",'X-Naver-Client-Id'=Client_ID, 'X-Naver-Client-Secret'=Client_Secret))
doc

# XML 구조로 변환
xmlFile = xmlParse(doc)
xmlFile

# XML 파일의 <item> 태그를 기준으로 데이터프레임으로 변환
df = xmlToDataFrame(getNodeSet(xmlFile, "//item"))
df
str(df)

# 전체 내용중에서 description 컬럼의 값만 추출
description = df[, 4]
description

# 불필요한 글자들 삭제
description2 = gsub("\\b|<b>|</b>|&quot;", "", description)
description2

# 뉴스 내용중에 명사만 추출
nouns = nouns(iconv(description2, "utf-8"))
nouns

# 기사 한개당 나누어져 있는 백터를 하나의 백터로 통합
nouns.all = unlist(nouns, use.names = F)
nouns.all

# 글자수가 2글자 이상인 단어만 추출
nouns.all.2 = nouns.all[nchar(nouns.all)>=2]
nouns.all.2

#단어들의 빈도수
nouns.freq = table(nouns.all.2)
nouns.freq

nouns.df = data.frame(nouns.freq)
nouns.df

# 데이터 프레임의 값 중에서 빈도수를 기준으로 내림차순 정렬
nouns.df.sortdesc = nouns.df[order(nouns.df$Freq),]
nouns.df.sortdesc

wordcloud2(nouns.df.sortdesc, size=1, rotateRatio = 0.5)

wordcloud2(nouns.df.sortdesc, size=0.3, shape= 'star')
