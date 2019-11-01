# shell 脚本入门到精通（中级）
<a href="#1">一、shell 脚本的执行</a>
<a href="#2">二、输出格式化</a>
<a href="#3">三、数据类型</a>
<a href="#4">四、重定向</a>
<a href="#5">五、变量</a>




# <a name="1">一、shell 脚本的执行</a>
## 1. 脚本执行的4种方法
	$ ls /tmp/test.sh
	/tmp/test.sh
```bash
#!/bin/bash
# test.sh
# 这里借助SHLVL这个变量，SHLVL可以显示shell的层级，
# 每启动一个shell，这个值就加1
echo "shell level :$SHLVL"
echo "hello world!"
```
1.  切换到shell脚本所在目录执行
    root@localhost:/# cd /tmp/
    root@localhost:/tmp# chmod +x test.sh
    root@localhost:/tmp# ./test.sh
    shell level :2
    hello world!

2.  以绝对路径执行

	root@localhost:~# chmod +x /tmp/test.sh
	root@localhost:~# /tmp/test.sh
	shell level :2
	hello world!
3. 直接使用bash或sh 来执行bash shell脚本

	root@localhost:/tmp# bash test.sh
	shell level :2
	hello world!
	root@localhost:/tmp# sh test.sh
	shell level :1
	hello world!
4. 在当前shell 环境中执行

	root@localhost:/tmp# . test.sh
	shell level :1
	hello world!
	root@localhost:/tmp# source  test.sh
	shell level :1
	hello world!

总结：注意看SHLVL的值，前3种方式都在子shell中执行（sh除外），第4种在当前shell种执行。

## 2.调试脚本
bash -x script.sh  跟踪调试shell脚本

例：

	root@localhost:/tmp# bash -x test.sh
	+ echo 'shell level :2'
	shell level :2
	+ echo 'hello world!'
	hello world!

-x 打印所执行的每一行命令以及当前状态
 set  -x : 在执行时显示参数和命令
 set +x : 禁止调试
 set -v : 当命令进行读取时显示输入
 set +v : 禁止打印输入

# <a name="2">二、输出格式化</a>
## 1. C语言风格的格式化
```bash
#!/bin/bash
printf "%-5s %-10s %-4s\n" NO. Name Mark
printf "%-5s %-10s %-4.2f\n" 1 Sarath 80.3456
printf "%-5s %-10s %-4.2f\n" 2 James 90.9989
```
	root@localhost:/tmp# ./test.sh
	NO.   Name       Mark
	1     Sarath     80.35
	2     James      91.00


## 2. echo
1. 不换行

	echo -n "hello world"
2. 转义

	echo -e "hello\t\tworld" 
3. 彩色输出

| 颜色   | 重置 | 黑   | 红   | 绿   | 黄   | 蓝   | 紫   | 青   | 白   |
| ------ | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 前景色 | 0    | 30   | 31   | 32   | 33   | 34   | 35   | 36   | 37   |
| 背景色 | 0    | 40   | 41   | 42   | 43   | 44   | 45   | 46   | 47   |

echo -e "\e[1;31m This is red test \e[0m"
或
echo -e  "\033[47;31m This is red test \033[0m"

# <a name="3">三、数据类型</a>
## 1.字符串
获取字符串长度

	root@localhost:/# str="hello"
	root@localhost:/# echo ${#str}
	5

## 2. 数组
1. 数组的定义

方法一：

	arr=(1 2 3 4 5)

方法二：

	arr[0]=1
	arr[1]=2
	arr[2]=3
	echo ${arr[*]}
	1 2 3

2. 打印数组中的值

	root@localhost:~# arr=(1 2 3 4 5)
	root@localhost:~# echo ${arr[2]}
	3
	root@localhost:~# echo ${arr[*]}
	1 2 3 4 5
	root@localhost:~# echo ${arr[@]}
	1 2 3 4 5

3. 关联数组 -- 数组的高级用法

普通数组只能使用整数作为索引值，而关联数组可以使用任意文本作为索引值（有点类似于Python中的字典，不知道这样理解对不对），关联数组只在bash 4.0以上支持。
查看bash版本的方法：

bash -version

关联数组的定义和使用

	root@localhost:~# declare -A person
	root@localhost:~# person=([name]="Wang" [age]=18)
	root@localhost:~# echo ${person[name]}
	Wang
	root@localhost:~# echo ${person[age]}
	18
	root@localhost:~# echo ${person[*]}
	Wang 18



# <a name="4">四、重定向</a>

| 符号 | 含义       | 用法                                                   | 例                                                  |
| ---- | ---------- | ------------------------------------------------------ | --------------------------------------------------- |
| <    | 标准输入   | 从文件中输入                                           | wc -l file.txt                                      |
| >    | 标准输出   | 目标文件不存在会新建一个；目标文件存在会覆盖原内容     | echo "<?php phpinfo();?>" > /var/www/html/index.php |
| >>   | 追加到文件 | 目标文件不存在会新建一个；目标文件存在会在文件末尾追加 | echo "add text" >> file.txt                         |

例：
从定向的用法

	# cat >> file.sh << EOF
	> #!/bin/bash
	> echo "hello"
	> EOF

/dev/null   相当于垃圾桶
例：把标准输出重定向到/dev/null

	yum makecache > /dev/null


# <a name="5">五、变量</a>

## 1. 只读变量

```bash
root@localhost:~# cat file.sh
#!/bin/bash
readonly hours_per_day=24
hours_per_day=12
```
更改变量会触发异常

	root@localhost:~# ./file.sh
	./file.sh: line 3: hours_per_day: readonly variable


## 2. 展开运算符

| 运算符              | 用途                                                         | 例                                                           |
| ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ${varname:-word}    | 如果变量存在且非null，则返回其值；<br>否则返回word           | # echo ${service:-"service is not defined"}<br>service is not defined |
| ${varname:=word}    | 如果变量存在且非null，则返回其值；<br>否则设置它的值为word并返回 | root@localhost:~# echo ${service:=httpd}                     |
| ${varname:+word}    | 如果变量存在且非null，则返回word;<br>否则返回null            | echo ${service:+1}                                           |
| ${varname:?message} | 如果变量存在且非null,则返回其值；<br>否则显示message，并退出当前脚本或命令;<br>message默认信息为：parameter null or not set | # echo ${b:?} <br>-bash: b: parameter null or not set <br> # echo ${b:?"not defined"}<br>-bash: b: not defined |