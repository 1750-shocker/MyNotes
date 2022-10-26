#### 构建Activity

1. **组件名称**

   如果没有组件名称，则 Intent 则为*隐式*，使用==目标组件的完全限定类名==指定此对象，其中包括应用的软件包名称。例如，`com.example.ExampleActivity`。您可以使用 `setComponent()`、`setClass()`、`setClassName()`，或 `Intent` 构造函数设置组件名称。

2. **action**

   指定要执行的通用操作（例如，*查看*或*选取*）的字符串。==action会在很大程度上决定其余 Intent 的构成，特别是数据和 extra 中包含的内容。==您可以指定自己的操作，供 Intent 在您的应用内使用（或者供其他应用在您的应用中调用组件）。但是，您==通常应该使用由Intent类或其他框架类定义的操作常量。==以下是一些用于启动 Activity 的常见操作：

   - `ACTION_VIEW`

     如果您拥有一些某项 Activity 可向用户显示的信息（例如，要使用图库应用查看的照片；或者要使用地图应用查看的地址），请通过 Intent 将此操作与 `startActivity()` 结合使用。

   - `ACTION_SEND`

     这也称为*共享* Intent。如果您拥有一些用户可通过其他应用（例如，电子邮件应用或社交共享应用）共享的数据，则应使用 Intent 将此操作与 `startActivity()` 结合使用。

   有关更多定义通用操作的常量，请参阅 `Intent` 类参考文档。其他操作在 Android 框架中的其他位置定义。例如，对于在系统的设置应用中打开特定屏幕的操作，将在 `Settings`中定义。

   您可以使用 `setAction()` 或 `Intent` 构造函数为 Intent 指定操作。

   如以下示例所示，如果==定义自己的操作==，请确保加入应用的软件包名称作为前缀：

   ```java
   static final String ACTION_TIMETRAVEL = "com.example.action.TIMETRAVEL";
   ```

3. **data**

   引用待操作数据和/或该数据 MIME 类型的 URI（`Uri` 对象）。提供的数据类型通常由 Intent 的操作决定。例如，如果操作是 `ACTION_EDIT`，则数据应包含待编辑文档的 URI。

   创建 Intent 时，除了指定 URI 以外，指定数据类型（其 MIME 类型）往往也很重要。例如，能够显示图像的 Activity 可能无法播放音频文件，即便 URI 格式十分类似时也是如此。因此，指定数据的 MIME 类型有助于 Android 系统找到接收 Intent 的最佳组件。但，有时 MIME 类型可以从 URI 中推断得出，特别当数据是 `content:` URI 时尤其如此。`content:` URI 表明数据位于设备中，且由 `ContentProvider` 控制，这使得数据 MIME 类型对系统可见。

   要仅设置数据 URI，请调用 `setData()`。要仅设置 MIME 类型，请调用 `setType()`。如有必要，您可以使用 `setDataAndType()` 同时显式设置二者。**注意：**若要同时设置 URI 和 MIME 类型，*请勿*调用 `setData()` 和 `setType()`，因为它们会互相抵消彼此的值。请始终使用 `setDataAndType()` 同时设置 URI 和 MIME 类型。

4. **category**

   一个包含应处理 Intent 组件类型的==附加信息==的字符串。您可以将任意数量的类别描述放入一个 Intent 中，但==大多数 Intent 均不需要类别。==可以使用 `addCategory()` 指定类别。以下是一些常见类别：

   - `CATEGORY_BROWSABLE`

     目标 Activity 允许本身通过网络浏览器启动，以显示链接引用的数据，如图像或电子邮件。

   - `CATEGORY_LAUNCHER`

     该 Activity 是任务的初始 Activity，在系统的应用启动器中列出。

   ==Android 会自动将 CATEGORY_DEFAULT 类别应用于传递给 startActivity() 和 startActivityForResult() 的所有隐式 Intent。如需 Activity 接收隐式 Intent，则必须将 "android.intent.category.DEFAULT" 的类别包括在其 Intent 过滤器中==

5. **Extra**

   携带完成请求操作所需的附加信息的键值对。Intent 也有可能会携带一些不影响其如何解析为应用组件的信息。正如某些操作使用特定类型的数据 URI 一样，有些操作也使用特定的 extra。您可以使用各种 `putExtra()` 方法添加 extra 数据，每种方法均接受两个参数：键名和值。您还可以创建一个包含所有 extra 数据的 `Bundle` 对象，然后使用 `putExtras()` 将 `Bundle` 插入 `Intent` 中。==Intent 类将为标准化的数据类型指定多个 EXTRA_*常量。==如需==声明自己的 extra 键==（对于应用接收的 Intent），请确保将应用的软件包名称作为前缀，如下例所示：

   ```java
   static final String EXTRA_GIGAWATTS = "com.example.EXTRA_GIGAWATTS";
   ```

   **注意**：在发送您希望另一个应用接收的 Intent 时，请勿使用 `Parcelable` 或 `Serializable` 数据。如果某个应用尝试访问 `Bundle` 对象中的数据，但没有对打包或序列化类的访问权限，则系统将提出一个 `RuntimeException`。

6. **flag**

   标志在 `Intent` 类中定义，充当 Intent 的元数据。标志可以指示 Android 系统如何启动 Activity（例如，Activity 应属于哪个[任务](https://developer.android.com/guide/components/tasks-and-back-stack?hl=zh-cn)），以及启动之后如何处理（例如，Activity 是否属于最近的 Activity 列表）。其实就是启动模式，singleTop,singleTask等

#### ==强制使用应用选择器==

如果多个应用可以响应 Intent，且用户可能希望每次使用不同的应用，则应采用显式方式显示选择器对话框。选择器对话框会要求用户选择用于操作的应用（用户无法为该操作选择默认应用）。例如，当应用使用 `ACTION_SEND` 操作执行“共享”时，用户根据目前的状况可能需要使用另一不同的应用，因此应当始终使用选择器对话框，

普通：

```
// Create the text message with a string
Intent sendIntent = new Intent();
sendIntent.setAction(Intent.ACTION_SEND);
sendIntent.putExtra(Intent.EXTRA_TEXT, textMessage);
sendIntent.setType("text/plain");

// Verify that the intent will resolve to an activity
if (sendIntent.resolveActivity(getPackageManager()) != null) {
    startActivity(sendIntent);
}
```

强制：

```
Intent sendIntent = new Intent(Intent.ACTION_SEND);
...

// Always use string resources for UI text.
// This says something like "Share this photo with"
String title = getResources().getString(R.string.chooser_title);
// Create intent to show the chooser dialog
Intent chooser = Intent.createChooser(sendIntent, title);

// Verify the original intent will resolve to at least one activity
if (sendIntent.resolveActivity(getPackageManager()) != null) {
    startActivity(chooser);
}
```

#### intent-filter

==应用组件应当为自身可执行的每个独特作业声明单独的过滤器。例如，图像库应用中的一个 Activity 可能会有两个过滤器，分别用于查看图像和编辑图像。==当 Activity 启动时，将检查 `Intent` 并根据 `Intent` 中的信息决定具体的行为（例如，是否显示编辑器控件）。您可以使用以下三个元素中的一个或多个指定要接受的 Intent 类型：

- [`<action>`](https://developer.android.com/guide/topics/manifest/action-element?hl=zh-cn)

  在 `name` 属性中，声明接受的 Intent 操作。该值必须是操作的文本字符串值，而不是类常量。

- [`<data>`](https://developer.android.com/guide/topics/manifest/data-element?hl=zh-cn)

  使用一个或多个指定数据 URI（`scheme`、`host`、`port`、`path`）各个方面和 MIME 类型的属性，声明接受的数据类型。

- [`<category>`](https://developer.android.com/guide/topics/manifest/category-element?hl=zh-cn)

  在 `name` 属性中，声明接受的 Intent 类别。该值必须是操作的文本字符串值，而不是类常量。

#### 确保*只有您自己的应用*才能启动您的某一组件

使用 Intent 过滤器时，无法安全地防止其他应用启动组件。==尽管 Intent 过滤器将组件限制为仅响应特定类型的隐式 Intent，但如果开发者确定您的组件名称，则其他应用有可能通过使用显式 Intent 启动您的应用组件。====如果必须，请勿在您的清单中声明 Intent 过滤器。而是将该组件的 [exported](https://developer.android.com/guide/topics/manifest/activity-element?hl=zh-cn#exported) 属性设置为 `"false"==

同样，为了避免无意中运行不同应用的 `Service`，请始终使用显式 Intent 启动您自己的服务。

**请注意：**对于所有 Activity，您必须在清单文件中声明 Intent 过滤器。但是，广播接收器的过滤器可以通过调用 `registerReceiver()` 动态注册。稍后，您可以使用 `unregisterReceiver()` 注销该接收器。这样一来，应用便可仅在应用运行时的某一指定时间段内侦听特定的广播。

#### 启动入口

```xml
<activity android:name="MainActivity">
    <!-- This activity is the main entry, should appear in app launcher -->
    <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
</activity>

<activity android:name="ShareActivity">
    <!-- This activity handles "SEND" actions with text data -->
    <intent-filter>
        <action android:name="android.intent.action.SEND"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <data android:mimeType="text/plain"/>
    </intent-filter>
    <!-- This activity also handles "SEND" and "SEND_MULTIPLE" with media data -->
    <intent-filter>
        <action android:name="android.intent.action.SEND"/>
        <action android:name="android.intent.action.SEND_MULTIPLE"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <data android:mimeType="application/vnd.google.panorama360+jpg"/>
        <data android:mimeType="image/*"/>
        <data android:mimeType="video/*"/>
    </intent-filter>
</activity>
```

- `ACTION_MAIN` 操作指示这是主要入口点，且不要求输入任何 Intent 数据。
- `CATEGORY_LAUNCHER` 类别指示此 Activity 的图标应放入系统的应用启动器。==如果\<activity>元素未使用 `icon` 指定图标，则系统将使用\<application>元素中的图标。==

这两个元素必须配对使用，Activity 才会显示在应用启动器中。

当收到隐式 Intent 以启动 Activity 时，系统会根据以下三个方面将该 Intent 与 Intent 过滤器进行比较，搜索该 Intent 的最佳 Activity：

#### action测试

```xml
<intent-filter>
    <action android:name="android.intent.action.EDIT" />
    <action android:name="android.intent.action.VIEW" />
    ...
</intent-filter>
```

Intent指定的一个action，必须匹配filter中多个action之一。

如果filter未指定action，则所有intent都不能通过该测试。

如果Intent未指定action，则只要过滤器内包含至少一项操作，就可以通过测试。

#### category测试

```xml
<intent-filter>
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    ...
</intent-filter>
```

Intent中指定的category在filter中都要有，别的不管，intent的类别可以不设置

#### data测试

```xml
<intent-filter>
    <data android:mimeType="video/mpeg" android:scheme="http" ... />
    <data android:mimeType="audio/mpeg" android:scheme="http" ... />
    ...
</intent-filter>
```

要指定接受的 Intent 数据，Intent 过滤器既可以不声明任何data元素，也可以声明多个此类元素

每个 `<data>` 元素均可指定 URI 结构和数据类型（MIME 媒体类型）。URI 的每个部分都是一个单独的属性：`scheme`、`host`、`port` 和 `path`：

```
<scheme>://<host>:<port>/<path>
```

下例所示为这些属性的可能值：

```
content://com.example.project:200/folder/subfolder/etc
```

在此 URI 中，架构是 `content`，主机是 `com.example.project`，端口是 `200`，路径是 `folder/subfolder/etc`。