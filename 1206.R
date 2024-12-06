library(ggplot2)

install.packages("plotly")
library(plotly)

x = c(10, 22, 28, 40, 48, 60, 67, 82, 92, 98)
y = c(12, 18, 27, 33, 38, 40, 43, 52, 55, 62)
df = data.frame(X = x, Y = y)

ggplot(df, aes(X, Y)) +
  geom_point() +
  labs(title = "산포도", x = "X", y = "Y") +
  coord_cartesian(xlim = c(0, 100), ylim = c(0, 70))

# 최소비용함수값
# A: y절편의 범위, B: 기울기


# A의 요소의 개수 : (200/0.1) + 1
# B의 요소의 개수 : (60/0.1) + 1
A = seq(-100, 100, by=0.1)
A

B = seq(-3, 3, by=0.1)
B

cost.mtx = matrix(NA, nrow=length(A), ncol=length(B))

for (i in 1:length(A)) {
  for (j in 1:length(B)) {
    err.sum <- 0
    
    for (k in 1:length(X)) {
      # 예측값
      y_hat <- B[j] * X[k] + A[i]
      
      # 잔차값: (예측값 - 실제값)의 제곱
      err <- (y_hat - Y[k])^2
      
      err.sum <- err.sum + err
    }
    # 비용함수값: 잔차값의 합계/X값의 길이
    cost <- err.sum / length(X)
    cost.mtx[i, j] <- cost
  }
}

cost.mtx[1:5, 1:5]

# 비용함수값의 범위
range(cost.mtx)

min(cost.mtx)

# 최소 비용함수 값의 행과 열의 위치
idx = which(cost.mtx == min(cost.mtx), arr.ind = TRUE)
idx

# y절편 : 2001개의 값 중에서 최소비용함수의 행의 번호의 값
# A[1108]

#기울기 : 61개의 값 중에서 B[36]
Bmin = B[idx[1, 2]]
Bmin

ggplot(df, aes(X, Y)) +
  geom_point() +
  labs(title = "산포도", x = "X", y = "Y") +
  coord_cartesian(xlim = c(0, 100), ylim = c(0, 70)) + 
  geom_abline(intercept=Amin, slope=Bmin,
              color='red', linetype = "dashed")