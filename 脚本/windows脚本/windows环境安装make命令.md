#### 一、Make简介

> Make 是一种流行的构建工具，常用于将源代码转换成可执行文件或者其他形式的输出文件(如库文件、文档等)。Make 可以自动化地执行编译、链接等一系列操作，提高开发效率。

-   Make 使用 Makefile 文件描述项目的构建过程，其中包含了源文件、目标文件以及编译和链接的命令等信息。Makefile 按照一定的规则解析，将源码和构建过程相互关联起来，执行具体的构建操作，生成目标文件或可执行文件。
    
-   Make 工具的优势在于它可以识别哪些文件被修改了，只编译修改过的部分，以提高构建速度。此外，Make 工具还支持基于条件的编译，也就是预处理器(preprocessor)功能，可以生成不同的输出文件用于不同的平台或不同的运行环境。
    
-   同时，Make 工具具有很好的跨平台性，可以在 Unix/Linux、Windows、Mac 等多种操作系统上使用，并且可以与多种编程语言搭配使用，如 C、C++、Java 等。
    

总之，Make 工具是一种非常实用的构建工具，可以帮助开发者高效地管理和构建项目。

#### 二、make常用命令

make：执行默认的或指定的目标(target)。

make clean：清除所有生成的文件(.o,obj,exe,lib等)。

make install：安装可执行文件或库文件到系统目录。

make uninstall：从系统中卸载已安装的可执行文件或库文件。

make distclean：删除配置文件和Makefile，恢复源代码目录的状态。

make package：将生成的代码打包成可发布的压缩包。

make test：运行单元测试或集成测试。

make help：显示Makefile中定义的所有目标及其说明信息。

make debug：开启调试模式，可以用于调试Makefile。

make dep：将源代码中的依赖关系写入Makefile，以便于自动化编译

#### 三、Makefile书写格式

```cobol
GOPATH:=$(shell go env GOPATH).PHONY: initinit:	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest	go install github.com/micro/micro/v3/cmd/protoc-gen-micro@latest	go install github.com/micro/micro/v3/cmd/protoc-gen-openapi@latest .PHONY: apiapi:	protoc --openapi_out=. --proto_path=. proto/microProject.proto .PHONY: protoproto:	protoc --proto_path=. --micro_out=. --go_out=:. proto/microProject.proto	.PHONY: buildbuild:	go build -o microProject *.go .PHONY: testtest:	go test -v ./... -cover .PHONY: dockerdocker:	docker build . -t microProject:latest
```

PHONY 是 Makefile 中的一个关键字，在 Makefile 的规则中表示伪目标，即不与任何文件名相关联的目标。使用 PHONY 关键字声明的目标，其中不包含真正的文件依赖，就算文件名与伪目标同名也不会被当做文件处理。

使用 PHONY 的作用是在将来对于相应的文件名，不会产生任何干扰，而且它可以帮助我们避免与系统中的文件或目录名称发生冲突。通常情况下，PHONY 目标都是一些命令，没有实际的文件产生，而是进行代码编译、测试、清理等等操作。

举个例子，比如我们在 Makefile 中定义了一个 clean 目标用于删除所有生成的二进制文件，那么我们可以使用 PHONY 将其声明为伪目标，这样一个名为 clean 的文件就不会在出现时被误认为是编译生成的文件，从而避免了无意间的误删。声明的语法格式如下：

```less
.PHONY: clean clean:    del *.exe
```

这里我们可以看到，clean 目标被声明为伪目标，在规则的下一行中，使用 del 命令删除所有 .exe 后缀的文件。

#### 四、windows环境安装

-   下载mingw[https://sourceforge.net/projects/mingw/](https://sourceforge.net/projects/mingw/)![image](https://i-blog.csdnimg.cn/blog_migrate/1cbc965bff556bf45aa33de0f37e24da.png)
    
-   运行已下载的mingw-get-setup.exe文件进行安装，默认下一步就好了，默认安装到C:\\MinGW 目录
    
-   将C:\\MinGW\\bin目录添加到环境变量path里
    
-   双击打开桌面上的MinGW Installer图标![image](https://i-blog.csdnimg.cn/blog_migrate/af25ea66c33fb4575ffb70351a2ace2f.png)
    
-   勾选上需要安装的package![image](https://i-blog.csdnimg.cn/blog_migrate/40cc9480cd54dc5a07fe6841b0e82aeb.png)
    
-   进行安装![image](https://i-blog.csdnimg.cn/blog_migrate/cfeefe2ec21a07953927270520b508e4.png)
    
-   更改名称，因为windows下这个命名为了mingw32-make.exe ,改为make 方便一点![image](https://i-blog.csdnimg.cn/blog_migrate/887a4b8c6e1b2ce1b344f89123af588c.png)
    
-   OK！到这里就安装结束了，可以正常使用了