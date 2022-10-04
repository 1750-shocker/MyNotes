# ViewBinding的使用

## step1:

``` kotlin
android{
    ...
    buildFeatures{
        viewBinding true
    }
}
```

## step2:

> 启动ViewBinding后，AS会为每一个布局文件生成一个对应的Binding类，且类名为驼峰式，例如：
>
> activity_main.xml -->ActivityMainBinding，使用如下代码来避免布局文件被生成Binding类

``` xml
<LinearLayout
    xmlns:tools="http://schemas.android.com/tools"
    ...
    tools:viewBindingIgnore='true'>
    ...
</LinearLayout>
```

### 在Activity中使用

```kotlin
class MainActivity : AppCompatActivity(){
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        val binding = ActivityMainBinding.inflate(layoutInflater)
        //inflate接收一个LayoutInflater参数，可以在Activity中直接获取到
        setContentView(binding.root)
        //调用Binding类的getRoot()函数，来得到布局中的根元素的实例
        binding.textView.text = "Hello World!"
    }
}
//申明成全局变量以在onCreate()以外的地方使用
class MainActivity : AppCompatActivity(){
    private lateinit var binding: ActivityMainBinding
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        binding.textView.text = "Hello World!"
    }
}
```

### 在Fragment中使用

```kotlin
class MainFragment : Frament(){
    private var _binding: FragmentMainBinding? = null
    private val binding get() = _binding!!
    
    override fun onCreateView(inflater:LayoutInflater, container:			   	      				VeiwGroup?.savedInstanceState:Bundle?):View{
        _binding = FragmentMainBinding.inflate(inflater, container, false)
        //Fragment中用三个参数的inflate()
        return binding.root
    }
    
    override fun onDestroyView(){
        super.onDestroyView()
        _binding = null //保证binding变量的有效生命周期是在onCreateView & onDestroyView之间
    }
}
```

java版

```kotlin
public class MainFragment extends Fragment{
    private FragmentMainBinding binding;
    
    @Override
    public View onCreateView(@NotNull LayoutInflater inflater, ViewGroup container, 			Bundle savedInstanceState){
        binding = FragmentMainBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }
    
    @Override
    public void onDestroyView(){
        super.onDestroyView();
        binding = null;
    }
}
```

### 在Adapter中使用

RecyclerView子项

```
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:layout_margin=5dp
    tools:context=".MainActivity">
	
	 <ImageView
        android:id="@+id/fruitImage"
        android:layout_width="40dp"
        android:layout_height="40dp"
        android:layout_gravity="center_horizontal"
        android:layout_marginTop="10dp" />

    <TextView
        android:id="@+id/fruitName"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="left"
        android:layout_marginTop="10dp" />

</LinearLayout>
```

adapter:

```kotlin
class FruitAdapter(val fruitList:List<Fruit>): 					   			      				RecyclerView.Adapter<FruitAdapter.ViewHolder>(){
    
    inner class ViewHolder(view:View):RecyclerView.ViewHolder(view){
        val fruitImage:ImageView = view.findViewById(R.id.fruitImage)
        val fruitName:TextView = view.findViewById(R.id.fruitName)
    }
    
    override fun onCreateViewHolder(parent:ViewGroup, viewType:Int):ViewHolder{
        val view = LayoutInflater.from(parent.context).inflate(R.layout.fruit_item, 				parent, false)
        return ViewHolder(view)
    }
    
    override fun onBindViewHolder(holder:ViewHolder, position:Int){
        val fruit = fruitList[position]
        holder.fruitImage.setImageResource(fruit.iamgeId)
        holder.fruitName.text = fruit.name
    }
    
    override fun getItemCount() = fruitList.size
}
```

​	使用ViewBinding后的Adapter

```kotlin
class FruitAdapter(val fruitList: List<Fruit>): 					   			      				RecyclerView.Adapter<FruitAdapter.ViewHolder>(){
    
    inner class ViewHolder(binding: FruitItemBinding): 				 	   	    					RecyclerView.ViewHolder(binding.root){
        val fruitImage:ImageView = binding.fruitImage
        val fruitName:TextView = binding.fruitName
    }
    
    override fun onCreateViewHolder(parent:ViewGroup, viewType:Int): ViewHolder{
        val binding = FruitItemBinding.inflate(LayoutInflater.from(parent.context,
              parent, false))
        return ViewHolder(binding)
    }
    
    override fun onBindViewHolder(holder:ViewHolder, position:Int){
        val fruit = fruitList[position]
        holder.fruitImage.setImageResource(fruit.iamgeId)
        holder.fruitName.text = fruit.name
    }
    
    override fun getItemCount() = fruitList.size
}
```

### 在引入布局中使用

在include的时候给被引入的布局添加一个id

```kotlin
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">

    <include 
        android:id="@+id/titleBar"
        layout="@layout/titlebar" />
    ...
</LinearLayout>

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        binding.titleBar.title.text = "Title"
        binding.titleBar.back.setOnClickListener {
        }
        binding.titleBar.done.setOnClickListener {
        }
    }

}
```

最外层的布局使用了merge标签，这就表示当有任何一个地方去include这个布局时，会将merge标签内包含的内容直接填充到include的位置，不会再添加任何额外的布局结构。但是很遗憾，如果使用这种写法的话，运行程序将会直接崩溃。因为merge标签并不是一个布局，所以我们无法像刚才那样在include的时候给它指定一个id。

``` kotlin
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">

    <include
        layout="@layout/titlebar" />

</LinearLayout>

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private lateinit var titlebarBinding: TitlebarBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        titlebarBinding = TitlebarBinding.bind(binding.root)
        setContentView(binding.root)
        titlebarBinding.title.text = "Title"
        titlebarBinding.back.setOnClickListener {
        }
        titlebarBinding.done.setOnClickListener {
        }
    }
}
```

