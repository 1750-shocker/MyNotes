## LayoutInflater

第一个参数：xml文件

第二个参数：rootView

第三个参数：attachToParent



第二个参数用来计算第一个参数的LayoutParams，如果没有，则第一个参数的位置属性失效

第三个参数如果是true表示立即将该View添加到rootView中，否则，表示稍后会在其他时候addToView，因为如Fragment和RecyclerView会自行添加控件，所以这些都添false，对于parentView，如果入参提供了，就写，实在没有才填null

