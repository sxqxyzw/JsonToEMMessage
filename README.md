###使用入口

`ChatViewController`类中点击导航栏右侧`插入`按钮，可以把Demo中`record_file`此文件的聊天记录加载出来，通过`EMConversation`验证，检索出对应的消息并插入。


###运行demo

运行前，需要先cd到`JsonToEMMessage`目录，执行`pod install`安装SDK和EaseUI

###导入目录

添加到App项目中，只需要把`JTMessage`文件夹整个拖入项目

###需要使用的方法

#####JTManager单例

```
//消息插入完成的block
@property (nonatomic, copy) JTInSertCompletionBlock insertCompletionblock;

//附件消息，附件下载结束，返回的block
@property (nonatomic, copy) JTDownloadCompletionBlock downloadCompletionblock;

//正则分隔json格式字符串聊天记录，用于消息记录文件的拆分数据（不一定需要使用）
- (NSArray *)regularExpression:(NSString *)jsonStr;

//验证是否为conversation会话所需要导入的消息
- (BOOL)isNeedImport:(RecordModel *)model
        conversation:(EMConversation *)conversation;

//执行插入
- (void)insertMessageRecords:(NSArray<RecordModel *> *)msgRecords;

```

####RecordModel对象初始化

```
- (instancetype)initWithJson:(NSString *)jsonStr;

```