这个模版更新修改自：https://www.overleaf.com/latex/templates/hua-dong-shi-fan-da-xue-shuo-bo-shi-lun-wen-latexmo-ban-2024jie/cdshhhfftbjg
华东师范大学心理与认知科学学院博士（硕士）论文模板
===
LaTeX File for Doctor (Master) Thesis of ECNU-SEI
---


### 毕业论文目录结构
+ **1_figures**             -(图片存储)
	+ logo					-(校徽,校名图片目录)
+ **1_tables**              -(表格存储)
	+ 01_abbreviation		-(横向表格样例)
+ **A_Preliminary Section**					
	+ inner-cover.tex		-(中文封面)
	+ inner-cover-en.tex	-(英文封面)
    + copyright.tex			-(原创性声明)
	+ member-list.tex		-(答辩成员名单)
    + abstract					-(中英文摘要目录)
    	+ abstract.tex			-(中文摘要)
    	+ abstract-en.tex		-(英文摘要)
    + graphic.tex (图表格式和目录)

+ **B_Main Body**				-(章节目录)
	+ chapter-1.tex			-(章节一)
	+ chapter-2.tex			-(章节二)
	+ chapter-3.tex			-(章节三)
	+ chapter-4.tex			-(章节四)
	+ chapter-5.tex			-(章节五，可任意增加新的章节，并在main.tex中添加对应代码)


+ **C1_References**				-(参考文献引用目录)
    + zotero_better-bibtex_auto-update.bib（参考文献)
	+ GBT7714-2005.bst		-(参考文献格式)
	+ GBT7714-2005NLang.bst	-(参考文献格式)
+ **C2_Appendix**
    + Chapter7_Appendix （附录内容）
    
+ **C3_Acknowledgement**
    + acknowledgement			-(致谢目录)
            + acknowledgement-tmlc.tex	-(查重版致谢，通常仅需保留标题)
    	+ acknowledgement.tex	-(致谢)

+ **format**					-(格式目录)
	+ format.tex			-(引用,定义)
    + settings.tex          -(一些命令)
    
+ **main**.tex					-(latex入口文件)
+ **readme**.md                 -(本说明文件)

### 毕业论文参数配置
以下的配置均在`main.tex`的前三行中完成。由于各年级、各院系的标准不同，同时专硕、学硕、博士间也有很大差异，因此，请务必仔细核对其中的每一项是否按照标准配置。如有必要，请修改`main.tex`中的代码以保证正确显示。

> 提示1：请提前咨询是否可以使用latex进行毕业论文的编写，部分学位在查重时仅支持word格式！
> 提示2：务必注意除default的各选项的拼写！任何拼写错误均会导致其**自动**转化为default参数，从而导致指定模式失效！

####  draftfigure
`\def \draftfigure {off} % on,off`

该参数用于描述是否开启草稿模式。在开启模式下，所有图片均以框线的形式展现，不显示具体图片，从而降低预览时间。

> 已知的问题：（1）在草稿模式下部分溢出右边界的字符会再多显示一个黑色的矩形框，关闭该模式即可消除。（2）由于还是需要读取整张图片的数据以获取其长和宽，因此实际上只是节约了图片在pdf模式下的渲染时间（即预览速度），而不是编译时间。

该参数接受两种输入：

- `on`：开启草稿模式，仅显示外框。其代码为：`\def \draftfigure {on} `。
- `off(default)`：关闭草稿模式，显示完整图片。其代码为：`\def \draftfigure {off} `。

#### docstyle
`\def \docstyle {normal} % normal,tmlc,anonymous`

该参数用于返回指定版本的论文，其接受三种输入：

- `tmlc`：该参数返回查重版本的论文，其开启了查重模式，并关闭盲审模式。
- `anonymous`：该参数返回盲审版本的论文，其开启了盲审模式。
- `normal(default)`：所有不属于上述模式的参数（不局限于normal）均会进入该模式，返回终稿版本的论文。

#### refstyle
`\def \refstyle {manual} % auto,manual`

该模板支持两种文献导入方式。仅在auto情况下采用bst自动模式录入文献，其余情况（不局限于manual）均使用用户自定义模式。

> 已知的问题：在overleaf中，该模式的切换不会消除切换前的warning。尽管无需处理，但是如果需要清除xxx is not found in database的warnings，请先点击“日志和生成的文件”中的“清除缓存文件”，再重新编译即可。

该参数接受两种输入：

- `auto`：指bst自动模式，其文献需要在`paper.bib`中修改。在输入后，由latex排版相关格式，由于部分文献可能缺少一定字段或格式不规范，可能导致实际输出与要求有细微差异，可自行检查并调整bst代码或bib的对应key。文献格式为：`@type{ref, key= {value}}`。
- `manual(default)`：指bib手动模式，其文献需要在`paper-manual.bib`中修改。在输入后，该模式不经过latex自动排版，由作者自行编辑所有参考文献格式。可通过第三方文献软件预览参考文献格式是否符合学校标准。在确保格式正确后，再复制到文章中。文献格式为\bibitem{ref}{按学校要求输入正确格式}。