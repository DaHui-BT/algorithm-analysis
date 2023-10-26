%算法分析

::: {font-size="28px"}

汇报人：王立辉、李宇航

:::

<link rel="stylesheet" href="style/user.css">



# 贪心算法

## 题目描述

[402. 移掉 K 位数字](https://leetcode.cn/problems/remove-k-digits/)【中等】

给你一个以字符串表示的非负整数 `num` 和一个整数 `k` ，移除这个数中的 `k` 位数字，使得剩下的数字最小。请你以字符串形式返回这个最小的数字。

**示例 1 ：**

```
输入：num = "1432219", k = 3
输出："1219"
解释：移除掉三个数字 4, 3, 和 2 形成一个新的最小的数字 1219 。
```

**示例 2 ：**

```
输入：num = "10200", k = 1
输出："200"
解释：移掉首位的 1 剩下的数字为 200. 注意输出不能有任何前导零。
```

**示例 3 ：**

```
输入：num = "10", k = 2
输出："0"
解释：从原数字移除所有的数字，剩余为空就是 0 。
```

**提示：**

- `1 <= k <= num.length <= 105`
- `num` 仅由若干位数字（0 - 9）组成
- 除了 **0** 本身之外，`num` 不含任何前导零

---

## 解题思路：

**思想一（暴力破解）：** 

- 当需要删除数字长度等于数字字符长度时 				== > 直接返回 ``"0"`` 
- 当数字字符中存在逆序数字时 									== > 从前往后删除造成逆序的逆序数
- 当删除所有逆序数字时，还不满足要删除个数时 	 == >  从后往前删除，即删除最大数字

**思想二（贪心算法）：** 

> 方法一所使用循环遍历整个数组的开销 + 移动数组的开销 ==> O(n^2) 级别，开销过大
>
> 改进办法：采用堆栈优化移动数组的时间开销

- 将每次访问的数字（该数字大于等于堆栈中最顶部的元素）存入栈中
- 当每次访问的数字（该数字小于堆栈中最顶部的元素）则从堆栈中弹出最顶部元素，并继续进行比较
- 当处理完整个数组后，如果此时需要删除字符的个数仍未满足，则将 top 值改为还需要删除的个数
- 当最终完成删除字符个数后
  - 判断该数组是否为空，为空则返回 0
  - 当该数组以 0 开始时则返回第一个非 0 位置的元素地址。
  - 全为 0 则只需返回含有一个 0 元素的字符数组

---

## 头文件及宏

所使用头文件：

```c
# include <stdio.h>
# include <string.h>
# include <stdlib.h>
```

项目中所定义的宏：

```c
# define IS_INVERSE(X,Y) (X > Y ? 1 : 0)
# define INDEX_CORRECT(I) (I = I < 0 ? 0 : I)
// improve
# define POP_STACK stack[top --]
# define PUSH_STACK stack[top ++] = num[i]
```

执行函数：

```c
int execRemoveKdigits() {
  // char num[] = "1432219", k = 3;
  // char num[] = "10200", k = 1;
  // char num[] = "9", k = 1;
  // char num[] = "100", k = 1;
  // char num[] = "112", k = 1;
  // char num[] = "1234567890", k = 9;
  char num[] = "10001", k = 4;

  char* res = removeKdigits(num, k);
  printf("the minmum number is %s\n", res);

  return 0;
}
```

---

## 函数主体

功能函数：

```c
void removeKdigit(char* num, int index, int length) {
  for (; index < length - 1; ++ index) {
    num[index] = num[index + 1];
  }
  num[length - 1] = '\0';
}
```

函数主体：

```c
char* removeKdigits(char* num, int k) {
  int len_s = strlen(num), temp = k;

  // when the num length is 1 and the remove number is the same as length of num
  if (len_s == k) {
    num[0] = '0';
    return num;
  }

  // when the num contain inverse order
  for (int i = 0; i < len_s - 1 && temp > 0; ++ i) {
    INDEX_CORRECT(i);

    if (IS_INVERSE(num[i], num[i + 1])) {
      removeKdigit(num, i, len_s - k + temp);
      i -= 2; temp --;
    }
  }

  // when the num not contain inverse order
  // then remove the last one
  if (temp > 0) {
    num[len_s - k] = '\0';
  }

  // judge the num is start at 0 or the num is ""
  if (strcmp("", num) == 0) { // the num is ""
    num[0] = '0'; num[1] = '\0';
  } else if (num[0] == '0' && num[1] != '\0') { // the num is like "0123" not like "0"
    int move_step = 0;
    while (num[move_step] == '0' && len_s - k > move_step + 1) {
      move_step ++;
    }
    num = &num[move_step];
  }

  return num;
}
```

---

## 时间空间复杂度：

空间复杂度分析：临时变量的开销；共 4 ==> O(1)

时间复杂度分析：

- 最优情况：``n = k``，(n表示数字字符长度，k表示要删除字符个数) 即数字字符长度等于要删除字符的长度 
  - 例如：``num = "123"，k = 3`` （num 表示数字字符）
  - 时间复杂度为 $$O(1)$$ 
- 最坏情况：``n = k - 1`` 且最后一个字符小于其前面所有字符 (n表示数字字符长度，k表示要删除字符个数) 
  - 例如：``num = "1234567890", k = 9`` (num 表示数字字符) 
  - 时间复杂度：$$O(n^2)$$ 
-  平均情况：$$O(n^2)$$ 

**提交截图：** 

<img src=".\img\贪心算法-1.png" style="zoom:90%;" />

---

## 优化版本：

> 由于每次删除字符导致运行时间加长，照成的开销过大，从而采用堆栈存储不需要删除的数字

函数主体

```c
// the remove number must be the ordered
// greed
char* removeKdigits_i(char* num, int k) {
  int len_s = strlen(num), top = 0;
  char* stack = malloc(sizeof(len_s));

  for (int i = 0; i < len_s; ++ i) {
    // will be delete num is not 0 
    // and stack is not empty
    // and the top num of stack is less than num[i]
    while (k > 0 && top > 0 && stack[top - 1] > num[i]) {
      POP_STACK;
      k --;
    }
   PUSH_STACK;
  }
  // if k != 0 then delete the stack last k nums
  top -= k;

  if (top == 0) { // when the stack is empty, it indicate that all the num is delete
    stack[0] = '0'; stack[1] = 0;
  } else { // when the stack is not empty
    int move_step = 0; // define the num string size which is start by 0
    // calculate the size of start by 0 num
    while (stack[0] == '0' && move_step < top - 1) move_step ++;
    // let string point to the first one which is not start by 0
    stack = &stack[move_step];
    stack[top - move_step] = 0;
  }

  return stack;
}

```

---

## 时间空间复杂度：

空间复杂度分析：临时变量的开销；共 $$n + 4 ==> O(n)$$ 

空间复杂度：

- 最优情况：``n = 0``，(n表示数字字符长度，k表示要删除字符个数) 即数字字符长度等于要删除字符的长度 
  - 例如：``num = ""，k = 0`` （num 表示数字字符）
  - 时间复杂度为 $$O(1)$$ 
- 最坏情况：``n = k - 1`` 且最后一个字符小于其前面所有字符 (n表示数字字符长度，k表示要删除字符个数) 
  - 例如：``num = "1234567890", k = 9`` (num 表示数字字符) 
  - 时间复杂度：$$O(2n)$$ 
- 平均情况：$$O(n)$$ 

**提交截图：** 

<img src=".\img\贪心算法-2.png" style="zoom:90%;" />



# 动态规划

## 题目描述

[516. 最长回文子序列](https://leetcode.cn/problems/longest-palindromic-subsequence/)【中等】

> 给你一个字符串 `s` ，找出其中最长的回文子序列，并返回该序列的长度。
>
> 子序列定义为：不改变剩余字符顺序的情况下，删除某些字符或者不删除任何字符形成的一个序列。

**示例 1： ** 

```md
输入：s = "bbbab"
输出：4
解释：一个可能的最长回文子序列为 "bbbb" 。
```

**示 例 2：** 

```md
输入：s = "cbbd"
输出：2
解释：一个可能的最长回文子序列为 "bb" 。
```

**提示：** 

- `1 <= s.length <= 1000` 
- `s` 仅由小写英文字母组成

---

## 解体思路：

**剖析问题：** 

- 问题具有 **最优子结构** ，即字符串 ``s`` 从 ``i`` 到 ``j`` (``0 <= i < s.length, 0 <= j < s.length``) 中存在最长的回文字符串。
- 问题具有 **重叠子问题** ，即字符串 ``s`` 为一直求解从 ``i`` 到 ``j`` (``0 <= i < s.length, 0 <= j < s.length``) 中存在最长的回文字符串。

:::::::::::::: {.columns}
::: {.column width="50%"}

**状态转移方程：** <img src="./img/动态规划动态转移方程.png" style="zoom:60%;" />
:::
::: {.column width="50%"}

- ``dp[i][j]`` 描述为从 ``i`` 到 ``j`` 的最长序列，初始化为 0
- 查找从 ``i`` 到 ``j`` 中最大的回文序列

- 每个对角线元素都应填为 1，由于从 ``i`` 到 ``i`` 为一个回文序列

:::
::::::::::::::

<div style="display: none;">$$f(x) = \begin{cases} dp[i][j] = dp[i-1][j-1] + 2, & s[i] = s[j], \\ dp[i][j] = max(dp[i+1][j], dp[i][j - 1]), & s[i] \neq s[j], \end{cases}$$</div>
**图文描述：** 

| i\j   |      | 0                           | 1                                             | 2                                             | 3                                                        | 4                                                        |
| ----- | ---- | --------------------------- | --------------------------------------------- | --------------------------------------------- | -------------------------------------------------------- | -------------------------------------------------------- |
|       |      | b                           | b                                             | b                                             | a                                                        | b                                                        |
| **0** | b    | <font color="blue">1</font> | <font color="red">``dp[1][0] + 2 = 2``</font> | <font color="red">``dp[1][1] + 2 = 3``</font> | <font color="red">``Max(dp[1][3], dp[0][2]) = 3``</font> | <font color="red">``dp[2][3] + 2 = 4``</font>            |
| **1** | b    | <font color="grey">0</font> | <font color="blue">1</font>                   | <font color="red">``dp[2][1] + 2 = 2``</font> | <font color="red">``Max(dp[2][3], dp[1][2]) = 2``</font> | <font color="red">``dp[2][3] + 2 = 3``</font>            |
| **2** | b    | <font color="grey">0</font> | <font color="grey">0</font>                   | <font color="blue">1</font>                   | <font color="red">``Max(dp[4][4], dp[3][4]) = 1``</font> | <font color="red">``dp[3][3] + 2 = 3``</font>            |
| **3** | a    | <font color="grey">0</font> | <font color="grey">0</font>                   | <font color="grey">0</font>                   | <font color="blue">1</font>                              | <font color="red">``Max(dp[4][4], dp[3][4]) = 1``</font> |
| **4** | b    | <font color="grey">0</font> | <font color="grey">0</font>                   | <font color="grey">0</font>                   | <font color="grey">0</font>                              | <font color="blue">1</font>                              |



---

## 代码

项目所使用的头文件：

```c
# include <stdio.h>
# include <string.h>
```

项目中定义的宏

```c
# define MAX(X, Y) (X > Y ? X : Y)

// 定义所在列数的宏
# define COL      j
# define COL_NEXT j + 1
# define COL_PRE  j - 1

// 定义所在行数的宏
# define ROW      (i % 2)
# define ROW_NEXT ((i + 1) % 2)
# define ROW_PRE  ROW_NEXT
```

执行函数：

```c
int execlongestPalindromeSubseq() {

  char s[] = "aabaa";
  int res = longestPalindromeSubseq_i(s);

  printf("the longest sequence length is %d\n", res);

  return 0;
}
```

---

## 初代版本

函数主体

```c
int longestPalindromeSubseq(char* s) {
  int len_s = strlen(s);
  int dp[len_s][len_s]; // dp[i][j] indicate the max palindrome subsequent which is belong the space from i to j
  
  memset(dp, 0, sizeof(dp));
  
  for (int i = len_s - 1; i >= 0; -- i) {
    dp[i][i] = 1; // each diagonal is 1
    for (int j = i + 1; j < len_s; ++ j) {
      if (s[i] == s[j]) { // when s[i] == s[j] then let dp[i][j] plus the begin and end
        dp[i][j] = dp[i + 1][j - 1] + 2;
      } else { // when s[i] != s[j] then choose the max between from i+1 to j and from i to j-1
        dp[i][j] = MAX(dp[i + 1][j], dp[i][j - 1]);
      }
    }
  }

  // due to the algorithm is reverse deduce the max subsequent
  return dp[0][len_s - 1];
}
```

---

## 时间空间复杂度：

- 空间复杂度分析：由于采用二维数组造成的开销，以及临时变量的开销；共 $$n^2 + 3 ==> O(n^2)$$ (n 为字符长度)

- 时间复杂度分析：采用两层嵌套循环 + 对数组的初始化；共 $$n^2 * 2 ==> O(n^2)$$ (n 为字符长度)

**提交截图：** 

<img src="./img/动态规划算法-1.png" style="zoom:90%;" />

---

## 优化版本

> 由于状态数组开辟的过大，导致该程序的空间复杂度过高，从而降低数组容量。由此而改进的代码如下。

代码主体

```c
int longestPalindromeSubseq_i(char* s) {
  int len_s = strlen(s), i = 0;
  int dp[2][len_s];

  memset(dp, 0, sizeof(dp));
  for (i = len_s - 1; i >= 0; -- i) {
    dp[ROW][i] = 1;
    for (int j = i + 1; j < len_s; ++ j) {
      if (s[i] == s[j]) {
        dp[ROW][COL] = dp[ROW_NEXT][COL_PRE] + 2;
      } else {
        dp[ROW][COL] = MAX(dp[ROW_NEXT][COL], dp[ROW][COL_PRE]);
      }
    }
  }

  return dp[ROW_PRE][len_s - 1];
}
```

---

## 时间空间复杂度：

- 空间复杂度分析：由于采用二维数组造成的开销，以及临时变量的开销；共 $$2n + 3 ==> O(n)$$ (n 为字符长度)

- 时间复杂度分析：采用两层嵌套循环 + 对数组的初始化；共 $$n^2 + 2n ==> O(n^2)$$ (n 为字符长度)

**提交截图：** 

<img src=".\img\动态规划算法-2.png" style="zoom:90%;" />



# 最短路径

## 题目描述

 [743. 网络延迟时间](https://leetcode.cn/problems/network-delay-time/) 【中等】

有 `n` 个网络节点，标记为 `1` 到 `n`。

给你一个列表 `times`，表示信号经过 **有向** 边的传递时间。 `times[i] = (ui, vi, wi)`，其中 `ui` 是源节点，`vi` 是目标节点， `wi` 是一个信号从源节点传递到目标节点的时间。

现在，从某个节点 `K` 发出一个信号。需要多久才能使所有节点都收到信号？如果不能使所有节点收到信号，返回 `-1` 。

:::::::::::::: {.columns}
::: {.column width="70%"}

**示例 1：**

```
输入：times = [[2,1,1],[2,3,1],[3,4,1]], n = 4, k = 2
输出：2
```

**示例 2：**

```
输入：times = [[1,2,1]], n = 2, k = 1
输出：1
```

**示例 3：**

```
输入：times = [[1,2,1]], n = 2, k = 2
输出：-1
```

:::

::: {.column width="30%"}

![](img/最短路径-example.png)

:::

::::::::::::::

---

## 图示过程

![](img\最短路径-1.png)

---

## 图示过程

![](img\最短路径-2.png)

---

## 图示过程

![](img\最短路径-3.png)

---

## 图示过程

![](img\最短路径-4.png)

---

## 图示过程

![](img\最短路径-5.png)

---

## 图示过程

![](img\最短路径-6.png)

---

## 图示过程

![](img\最短路径-7.png)

---

## 图示过程

![](img\最短路径-8.png)

---

## 图示过程

![](img\最短路径-9.png)

---

## 图示过程

![](img\最短路径-10.png)

---

## 图示过程

![](img\最短路径-11.png)

---

## 图示过程

![](img\最短路径-12.png)

---

## 图示过程

![](img\最短路径-13.png)

---

## 代码分析

```c
//G为图，数组d为源点到达各点的最短路径长度，s为起点
Dijkstra(G,d[],s)
{
	初始化；
	for(循环n次)
	{
		u = 使d[u]最小的还未被访问的顶点的标号；
		标记u为已被访问；
		for(从u出发能到达的所有顶点v)
		{
			if(v未被访问&&以u为中介点使s到顶点v的最短距离d[v]更优)
			{
				优化d[v]；
				(令u为v的前驱)用于求最短路径本身
			}
		}
	}
}
// 递归求最短路径：
void DFS(int s,int v)//s为起点编号，v为当前访问的顶点编号(从终点开始递归)
{
	if(v==s)//如果当前已经到达起点s，则输出起点并返回
	{
		printf("%d\n",s);
		return;
	}
	DFS(s,pre[v]);//递归访问v的前驱顶点pre[v]
	printf("%d\n",v);//从最深处return回来之后，输出每一层的顶点号
}
```

---

## 算法设计

```python
class Solution(object):
    def networkDelayTime(self, times, n, k):
        """
        :type times: List[List[int]]
        :type n: int
        :type k: int
        :rtype: int
        """
        SEEN ={}
    	UNSEEN = {i+1:float('inf') for i in range(n)}
    	UNSEEN[k]=0

    	while len(SEEN)<n:
            temp = list(UNSEEN.items())    #将字典中所有的键值对转变为列表
            temp.sort(key= lambda x:x[1])  #将字典按值排序

            for i in range(len(temp)):     #遍历每个节点
                # 如果第i个节点不在SEEN中
                if temp[i][0] not in SEEN:
                    #将键-值对 temp[i][0]:temp[i][1]写入SEEN中
                    SEEN[temp[i][0]]=temp[i][1]

                    for link in times:
                        ui,vi,wi = link
                        if ui==temp[i][0]:
                            UNSEEN[vi] = min(UNSEEN[vi],SEEN[temp[i][0]]+wi)
                    break
    	s = list(SEEN.items())
    	s.sort(key= lambda x:x[1],reverse=True)
    	res =s[0][1]  if s[0][1]!=float('inf') else -1
    	return res

```

:::::::::::::: {.columns}
::: {.column width="50%"}

- 时间复杂度为：$$O(n^2)$$ ，其中 n 是节点数

:::

::: {.column width="50%"}

- 空间复杂度为：$$O(n)$$ 

:::
::::::::::::::

**运行结果** 

<img src="./img/最短路径运行结果.png" style="zoom:80%;" />



# 分治算法

## 题目描述

[50. Pow(x, n)](https://leetcode.cn/problems/powx-n/) 【中等】

实现 [pow(*x*, *n*)](https://www.cplusplus.com/reference/valarray/pow/) ，即计算 `x` 的整数 `n` 次幂函数（即，`xn` ）。 

**示例 1：**

```
输入：x = 2.00000, n = 10
输出：1024.00000
```

**示例 2：**

```
输入：x = 2.10000, n = 3
输出：9.26100
```

**示例 3：**

```
输入：x = 2.00000, n = -2
输出：0.25000
解释：2-2 = 1/22 = 1/4 = 0.25
```

---

## 解题分析

- 例：求 $$x^{64}$$ ，可以按照 $$x^1->x^2->x^4->x^8->x^{16}->x^{32}->x^{64}$$ 

  从 x 开始，每次直接把上一次的结果进行平方，计算 6 次就可以得到 $$x^{64}$$ 的值，而不需要对 x 乘 63 次 x 。

- 例：求 $$x^{67}$$ ，可以按照  $$x^1->x^2->x^4->x^9->x^{19}->x^{38}->x^{77}$$ 
  -  $$x^1->x^2, x^2->x^4, x^{19}->x^{38}$$ 这些步骤中可以直接把上一次的结果进行平方
  - $$x^4->x^9, x^9->x^{19}, x^{38}->x^{77}$$ 这些步骤中则需要在上一次的结果进行平方后再乘 x

1. 可以从右往左分析，要计算 $$x^n$$ 时，我们可以先递归地计算出 $$y=x^{⌊n/2⌋}$$ ；
2. 根据递归计算的结果,如果n为偶数,那么 $$x^n=y^2$$ ;如果n为奇数,那么 $$x^n=y^{2} * x$$ ；
3. 递归的边界为 n=0 ，任意数的 0 次方均为 1 ；

**伪代码描述：** 

```python
Divide-and-Conquer
	if P≤n0								 # P表示问题的规模,n0为下限
    	then return(表达式)　　			  # 当问题的规模小于某个数后,就能直接求出,不用再分解
    DivideP-> P1 ,P2 ,…,Pk　　			# 将P分解为较小的子问题
    for i=1 to k　　
    	do = Divide-and-Conquer(Pi) 		# 递归解决Pi　　
    T = MERGE(y1,y2,…,yk) 					# 合并子问题　　
```

---

## 算法设计

```python
class Solution(object):
    def myPow(self, x, n):
        """
        :type x: float
        :type n: int
        :rtype: float
        """
        def quickMul(n):
            # 如果n是0，则返回1    因为任意x的0次方都是1
            if n == 0:
                return 1.0
            # 如果n不为0
            y = quickMul(n // 2)
            # 若n是偶数，则返回y的平方
            # 若n是奇数，则返回y的平方再乘x
            if n % 2 == 0:
                return y * y
            else:
                return y * y * x
        return quickMul(n) if n >= 0 else 1.0 / quickMul(-n)

```

:::::::::::::: {.columns}
::: {.column width="40%"}

- 时间复杂度:O(logn)。即为递归的层数；

:::

::: {.column width="60%"}

- 空间复杂度:O(logn)。即为递归的层数，因为递归的函数调用会使用栈空间

:::
::::::::::::::

运行结果：

<img src="img\分治算法-运行结果.png" style="zoom:80%;" />

