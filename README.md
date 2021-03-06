# 命令行工具集

### dart 插件  
1. 在`pubspec.yaml`将脚本注册为可执行程序,可以注册多个    
```
# 包名: 脚本名称
executables:
  apk: main
  cert: cert
```
命令名称就是包名，如注`apk: main` ,在命令行中直接运行`apk <commond> [args]`    

2. 进入项目根目录，将文件包注册到全局。也可以在任意目录，--source path [包路径]

```
# 注册到全局
> pub global activate --source path ./
···
Package apk is currently active at path "D:\xxx\apk_tool".
Installed executables apk and cert.
Activated apk 1.0.0 at path "D:\xxx\apk_tool".

# 查看全局包列表
> pub global list
apk 1.0.0 at path "D:\xxx\apk_tool"
···

# 解除注册
> pub global deactivate apk

```

3. 运行脚本,测试命令
```
> apk
apk tools

Usage: apk <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  printcert   print apk cert infomation

Run "apk help <command>" for more information about a command.
```

    
### native 可执行程序  
需要`dart2native`,如果找不到这个命令，可以在sdk目录中找到`dart2native.bat`所在目录并配置到环境变量

```
# 在main.dart同级目录下生成 main.exe
> dart2native  bin\main.dart

# 也可以指定输出文件路径和文件名，或者手动修改文件名
> dart2native  bin\main.dart -o apk.exe
```
生成文件后，就可以在exe同级目录下执行脚本命令。    
将exe文件添加到环境变量path中，就可以在全局执行脚本命令。    
注意：命令名称是exe文件的名字，不再是包名，如生成的是`main.exe`,那命令就是`main <commond> [args]`,生成的是`apk.exe`,那命令就是`apk <commond> [args]`


    
    
### dart2native 参数
```
# 第一个参数是主Dart文件的路径
> dart2native <main-dart-file> [<options>]

# 定义一个环境声明，可以使用String.fromEnvironment()构造函数读取该声明. 要指定多个声明，请使用多个选项或使用逗号分隔键值对.
-D <key>=<value> or --define=<key>=<value>

# Enables assert statements.
--enable-asserts

# 指定输出类型，其中exe是默认值
-k (aot|exe) or --output-kind=(aot|exe)

# 指定输出文件路径和文件名,若不指定则默认在脚本目录下生成同名exe文件
-o <path> or --output=<path>

# 指定软件包解析配置文件的路径
-p <path> or --packages=<path>

# 显示更多信息
-v or --verbose


```


