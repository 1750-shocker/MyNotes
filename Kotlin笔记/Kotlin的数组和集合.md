# Kotlin的数组和集合

### 数组

```kotlin
fun ArrayExercise() {
        //方法1：指定元素，使用xxOf，直接列出元素，kotlin进行类型推导
        var aar1 = arrayOf("Java", "Kotlin", "Swift", "GO")
        var intArr1 = intArrayOf(1, 3, 200, -12)//Byte,Short,Int等基本类型XxxArray类
        //方法2：指定长度，并将元素初始化为null，因无法从后面的代码推断元素类型，需要使用泛型指定元素类型
        var arr2 = arrayOfNulls<Double>(5)//指定长度，元素为null
        var intArr2 = arrayOfNulls<Int>(21)
        //方法3：不指定长度和参数，指定元素类型
        var arr3 = emptyArray<String>()//长度为0的空数组
        var intArr3 = emptyArray<Int>()

        /**
         * 方法4：指定长度，并接收lambda动态计算各元素的值
         * 参数1：数组长度，参数2：lambda表达式初始化元素
         */
        var arr4 = CharArray(5) { (it * 2 + 97).toChar() }//Byte,Short,Int等基本类型XxxArray类
        var strArr4 = Array(6) { "fkit" }

        //8种基本类型数组：
        //byte[],   short[],    int[],  long[],   char[],   float[],   double[],   boolean[]
        //ByteArray,ShortArray,IntArray,LongArray,CharArray,FloatArray,DoubleArray,BooleanArray
        //在forin中使用数组索引
        for (i in arr4.indices) {
            println(arr4[i])
        }
    }

    fun ListExercise() {
        //不可变，返回List
        var list1 = listOf("Java", "Kotlin", null, "Go")
        println(list1)
        //返回不包含null的List
        var list2 = listOfNotNull("Java", "Kotlin", null, "Go")
        println(list2)
        //可变，返回MutableList
        var mutableList = mutableListOf("Java", "Kotlin", null, "Go")//可以接收0个参数
        //可变，返回ArrayList
        var arrayList = arrayListOf<String>("Java", "Kotlin", "Go")//可以接收0个参数
    }
```
