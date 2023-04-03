# 魔法补完计划

[TOC]

# 1 个人信息

| 条目     | 内容         |
| -------- | ------------ |
| 姓名     | thysrael     |
| 学号     | xxxxxxx      |
| 学院     | xxxxxxx      |
| 年级     | 大三         |
| 项目名称 | 魔法补完计划 |

----



# 2 指标核验

| 指标                 | 内容                                                         |
| -------------------- | ------------------------------------------------------------ |
| 选择内容             | 选择“简易电子商务系统”                                       |
| 代码完整，可以部署   | 功能基本上与大作业要求大体一致                               |
| 无明显 bug           | 可以通过 `rake test` ，在部署前也通过 `test` 测试            |
| 有设计文档           | 见下文**设计文档**一节                                       |
| 有使用手册           | 见下文**使用手册**一节                                       |
| 有较好的人机功能交互 | 通过 scss 和 JavaScript 优化了用户体验，见下文**使用手册**一节 |
| 独立完成             | 不存在直接使用课件上的内容，抄袭的现象。参考了《Agile Web Development with Rails》的部分内容 |
| 对下一届有参考价值   | 详细完整记录了自己增量式开发的每一个步骤（共 8800 字），可根据内容复现开发，见下文**开发日志**一节 |

---



# 3 设计文档

## 3.1 设计需求

该项目名为**“魔法补完计划”**，是一个简易的电商平台，针对于一个书商，多个购书用户进行开发。

### 3.1.1 买家侧需求

#### 3.1.1.1 浏览商品

用户可以浏览商家上架的所有商品，并且可以了解这些商品的基本信息，包括商品图片，商品描述，商品价格，商品折扣等信息。

#### 3.1.1.2 购物车

用户可以在浏览商品的时候，选择将商品加入购物车，以为后续的订单操作做准备，用户可以选择购物车中商品的种类和数量。同时购物车应当具有价格指示功能，可以计算当前购物车内商品的价格。

#### 3.1.1.3 订单

用户可以根据购物车中的内容生成订单，并且填写订单相关的信息，比如说收货人，地址，电话，邮箱等。

#### 3.1.1.4 收藏夹

用户可以将自己喜欢的产品加入收藏夹，可以浏览自己的收藏夹，可以删除收藏夹中的条目。

#### 3.1.1.5 促销活动

用户可以浏览促销活动，并且知悉促销活动都涉及哪些商品。

### 3.1.2 卖家侧需求

#### 3.1.2.1 CRUD 商品

管理员可以对上平进行增删改查操作。

#### 3.1.2.2 订单管理

管理员获得所有订单的详细信息，并且可以删除订单信息。

#### 3.1.2.3 促销管理

可以创建促销活动，并且选择促销的力度，可以选择促销涉及的商品，并且可以取消活动。

### 3.1.3 网站需求

#### 3.1.3.1 权限管理

对于不同身份的用户，需要有不同的权限，买家不能随意修改卖家商品的价格......

#### 3.1.3.2 网站响应性

网站应当具有良好的响应性，可以对用户的操作快速做出反应。

#### 3.1.3.3 安全性

网站应当保护用户的信息，避免用户信息泄露。

#### 3.1.3.4 美观

网站应当让用户有舒适自然的体验，同时具有一定的美学风格。

## 3.2 开发环境

- ruby: 3.1.2
- rails: 7.0.4
- database: sqlite 3.4
- pc: manjaro
- IDE: RubyMine

## 3.3 概念模型

![](README/book.png)

可以看到， ER 图中存在多个“多对多”关系，这是有意为之的，相比原要求中要求的多个属性，我更想体验更加复杂关系的开发，所以实现了**收藏夹**和**促销活动**两个功能，这两个功能都是“多对多”关系的，相应的，消除了原要求中的“颜色，尺寸”等单独成表，这种方式过于冗余，有一种“为了凑个数而凑表”之嫌。

## 3.4 数据模型

`rails` 方便的提供了数据库的视图在 `projec/db/schema.rb` 中，我的如下所示，可以看到我一共是 9 张表。

```ruby
ActiveRecord::Schema[7.0].define(version: 2023_01_03_154008) do
  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discount"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favor_items", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_favor_items_on_product_id"
    t.index ["user_id"], name: "index_favor_items_on_user_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "cart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1
    t.integer "order_id"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "email"
    t.string "phone"
    t.integer "pay_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "image_url"
    t.decimal "price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prompts", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_prompts_on_activity_id"
    t.index ["product_id"], name: "index_prompts_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "favor_items", "products"
  add_foreign_key "favor_items", "users"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "products"
  add_foreign_key "prompts", "activities"
  add_foreign_key "prompts", "products"
end
```

## 3.5 设计特色

### 3.5.1 多对多关系

概念模型中大量采用了多对多关系，这是对于 blog4 中 FollowShip 的拓展。

### 3.5.2 测试 test

对于增量式开发，基本上每增加一个功能，都完成了一个对应的单元测试，最终可以通过 `test` 。

### 3.5.3 响应性

利用了 `Ajax` 的知识，尽量提高了页面的响应速度。如下面的代码

```html
<% cache @products do %>
  <% @products.each do |product| %>
    <% cache product do %>
      <div class="entry">
        <%= image_tag(product.image_url) %>
        <h3><%= product.title %></h3>
        <%= sanitize(product.description) %>
        <div class="price_line">
          <!-- 显示价格 -->
          <span class="price"><%= number_to_currency(product.price) %></span>
          <!-- 显示折扣 -->
          <% product.prompts.each do |prompt| %>
            <span> &times; <%= number_to_percentage(prompt.activity.discount, precision: 0) %></span>
          <% end %>
        </div>
        <div class="bt_line">
          <!-- 加入购物车 -->
          <%= button_to '加入购物车', line_items_path(product_id: product), remote:true, class: 'bt' %>
          <!-- 加入收藏夹 -->
          <%= button_to '加入收藏夹', favor_items_path(product_id: product), class: 'bt' %>
        </div>
      </div>
    <% end %>
  <% end %>
<% end %>
```

----



# 4 使用手册 & 功能展示

## 4.1 非登录状态

在非登录状态可以进行一些网页的浏览和功能，比如说商品目录

![image-20230105110222171](README/image-20230105110222171.png)

但是比如说需要支付订单的时候，就会自动重定向到登录界面。

## 4.2 登录

登录界面如图所示

![image-20230105110333705](README/image-20230105110333705.png)

有登录和注册两个选项，对于已经有账号的用户，可以直接登录，正确的密码即可登录，错误的密码会报错，如下所示

![image-20230105110618864](README/image-20230105110618864.png)

正确的密码可以登录，登录后会在左侧面板上显示用户名和登出按键

![image-20230105110723041](README/image-20230105110723041.png)

可以看到，随着登录功能，用户的权限增大了（上部导航栏导航增多）

## 4.3 注册

可以选择注册界面需要输入用户名，密码，并且确认密码，同时需要输入自己的身份。

![image-20230105110929477](README/image-20230105110929477.png)

## 4.4 购物车

用户浏览商品的时候，可以将商品加入购物车，购物车面板会在左侧出现，同时还会显示经过折扣后的价格和购物车的价格总值，用户可以选择清空购物车或者根据购物车中的内容生成订单

![image-20230105111832195](README/image-20230105111832195.png)

## 4.5 订单

用户点击“结算”按键，就可以进入订单信息完善界面，通过填写信息生成订单

![image-20230105111912004](README/image-20230105111912004.png)



在管理侧，可以查看订单信息：

订单总览

![image-20230105113505676](README/image-20230105113505676.png)

订单详情：

![image-20230105113526332](README/image-20230105113526332.png)

## 4.6 收藏

用户可以点击商店界面的“加入收藏夹”按钮，即可收藏该商品，在“收藏”这个导航中可以看到用户收藏的所有商品

![image-20230105114641256](README/image-20230105114641256.png)

用户可以选择将收藏品加入购物车，同时还可以将收藏品从收藏夹中移除。

## 4.7 促销

每个促销活动会涉及一些商品，会让商品有一些折扣力度，这些会反应到客户的实际消费中，客户可以在商店界面看到每个商品的折扣力度：

![image-20230105115612997](README/image-20230105115612997.png)

同时用户也可以直接浏览当前的活动，看到涉及的产品和折扣力度

![image-20230105115647072](README/image-20230105115647072.png)

在管理侧，可以创建活动并且选择加入活动的产品

![image-20230105115809680](README/image-20230105115809680.png)

![image-20230105115818279](README/image-20230105115818279.png)

## 4.8 商品管理

管理员可以对产品进行增删改查操作

![image-20230105115837059](README/image-20230105115837059.png)

## 4.9 用户管理

管理员可以对用户进行增删改查操作

![image-20230105120139006](README/image-20230105120139006.png)

---



# 开发日志

## 5.1 产品 Product

### 5.1.1 创建 Product

创建名为 `project` 的 rails 应用

```shell
rails new project
```

创建 `Product` 模型

```shell
rails generate scaffold Product title:string description:text image_url:string price:decimal
```

这会生成一个 `migration` ，我们需要进一步修改这个迁移，保证价格拥有 8 位有效数字，同时小数点后保留两位。修改迁移文件

```ruby
class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
```

然后就可以进行 `migrate`

```shell
rake db:migrate
```

这里的 `rake` 可以被理解为一个脚本的管理器，`db:migrate` 是其中的一个脚本。还有一种说法是 `rake` 类似与 C 中的 `make`

最终我们对于数据库的修改，都会被记录在 `db/schema.rb` 中，比如说现在

```ruby
ActiveRecord::Schema[7.0].define(version: 2022_12_31_030243) do
  create_table "products", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "image_url"
    t.decimal "price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
```

可以看到基本上与 `migration` 是一致的，原来的 `t.timestamps` 时间戳变成了 `created_at` 和 `updated_at` 两个属性。此外主键被叫做 `product_id` ，并没有在这里显示，这应该是一种默认配置。

### 5.1.2 本地服务器

我们输入如下命令，就可以在本地启动服务器

```shell
rails s
```

会看到如下字样

```shell
=> Booting Puma
=> Rails 7.0.4 application starting in development
```

其中的 `Puma` 似乎是一个线程管理器，每个线程都用于处理来自客户端的一个 `request` 。

### 5.1.3 表单

`app/views/products/_form.html.erb` 是一个局部渲染文件，用于当做 `product` 信息的表单，这个表单会在 `new.html.erb, edit.html.erb` 这两个文件中用到，如下所示

```html
<h1>New product</h1>

<!-- 这里对表单进行局部渲染，并且传递局部参数 product -->
<%= render "form", product: @product %>

<br>

<div>
  <%= link_to "Back to products", products_path %>
</div>
```

关于局部渲染，有如下知识：https://blog.csdn.net/weixin_30621711/article/details/96260112

表单的具体内容如下

```html
<!-- form_with 是 rails 所带的一种表单形式，类似的还有 form_for -->
<%= form_with(model: product) do |form| %>
  <!-- product 如果存在问题 -->
  <% if product.errors.any? %>
    <div style="color: red">
      <h2><%= pluralize(product.errors.count, "error") %> prohibited this product from being saved:</h2>

      <ul>
        <% product.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <!-- product 的 title -->
  <div>
    <!-- title 表项 -->
    <%= form.label :title, style: "display: block" %>
    <!-- title 具体内容 -->
    <%= form.text_field :title %>
  </div>

  <!-- product 的 description -->
  <div>
    <%= form.label :description, style: "display: block" %>
    <!-- 这里将产品描述的行数和列数进行了自定义增大 -->
    <%= form.text_area :description, rows: 10, cols: 60 %>
  </div>

  <!-- product 的 image_url -->
  <div>
    <%= form.label :image_url, style: "display: block" %>
    <%= form.text_field :image_url %>
  </div>

  <!-- product 的 price -->
  <div>
    <%= form.label :price, style: "display: block" %>
    <%= form.text_field :price %>
  </div>

  <!-- 填完表单后提交 -->
  <div>
    <%= form.submit %>
  </div>
<% end %>

```

需要注意我们将表单的产品描述部分的输入框变大了

```html
<!-- 这里将产品描述的行数和列数进行了自定义增大 -->
<%= form.text_area :description, rows: 10, cols: 60 %>
```

### 5.1.4 seeds

如果数据库不是同一个（一般本地开发多个，云端一个），那么测试数据就成了“个人私有”的，显然是低效的，我们可以给数据库一组“初始值“（也就是种子，seeds），这组初始值我们可以在 `db/seeds.rb` 中给出，如下所示

```ruby
Product.delete_all

Product.create(title: 'Programming Ruby 1.9',
               description:
                 %{
              <p>
                Ruby is the fastest growing and most exciting dynamic language out there.
              </p>
              },
               image_url: 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwww.kfzimg.com%2Fsw%2Fkfzimg%2F1575%2F012f2857fe9a2966a5_b.jpg&refer=http%3A%2F%2Fwww.kfzimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1668567051&t=61ed25128b60ad15cbe2c21729511f99',
               price: 49.50
)
```

然后运行

```shell
rake db:seed
```

就可以添加这个数据。

### 5.1.5 SCSS

​	当前的 `products` 页面过于丑陋，可以考虑给所有的产品界面一组样式，这里我们用 `scss` 实现，在 `app/assets/stylesheets/` 中创建 `products.scss` 并写入下面的内容

```scss
.products {
  table {
    border-collapse: collapse;
  }

  table tr td{
    padding: 5px;
    vertical-align: top;
  }

  .list_image {
    width: 60px;
    height: 70px;
  }

  .list_description {
    width: 60%;

    dl {
      margin: 0;
    }

    dt {
      color: #244;
      font-weight: bold;
      font-size: larger;
    }

    dd {
      margin: 0;
    }
  }

  .list_actions {
    font-size: x-small;
    text-align: right;
    padding-left: 1em;
  }

  .list_line_even {
    background: #e0f8f8;
  }

  .list_line_odd {
    background: #e2c3e2;
  }
}
```

​	然后就会发现运行不了，这是因为 `rails` 默认不能处理 `scss`，需要在 `gemfile` 中加入如下依赖

```ruby
# Use Sass to process CSS
gem "sassc-rails"
gem 'bootstrap-sass'
```

然后命令行运行

```shell
bundle install
```

这是因为

> rake是Ruby语言的构建工具，它的配置文件是Rakefile。
>
> gem是Ruby语言的包管理工具，它的配置文件后缀是.gemspec。
>
> bundler是Ruby语言的外部依赖管理工具，它有一个别名叫”bundle”，它的配置文件是Gemfile。

然后在 `views/layouts/application.html.erb` 中需要进行修改，加上每个类对应不同的 `scss` 。

```html
<body class='<%= controller.controller_name %>'>
    <%= yield %>
</body>
```

 `views/layouts/application.html.erb` 是一个布局页面，会对每一个页面都适用。

最后写一下 `index.html.erb` 的具体信息

```html
<div id="product_list">
  <h1>Products</h1>

  <table>
    <% @products.each do |product| %>
      <tr class="<%= cycle('list_line_odd', 'list_line_even') %>">
        <td>
          <%= image_tag(product.image_url, class: 'list_image') %>
        </td>

        <td class="list_description">
          <dl>
            <dt><%= product.title %></dt>
            <dd><%= truncate(strip_tags(product.description), :length => 80) %></dd>
          </dl>
        </td>

        <td class="list_actions">
          <%= link_to 'Show', product %><br/>
          <%= link_to 'Edit', edit_product_path(product) %><br/>
          <%= link_to 'Destroy', product, :confirm => 'Are you sure?', :method => :delete %>
        </td>
      </tr>
    <% end %>
  </table>
</div>

<br/>

<%= link_to 'New product', new_product_path %>
```

### 5.1.6 验证

可以在模型层对于模型的属性添加验证，对于 `Product` 来说有如下验证

```ruby
class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {:greater_than_or_equal_to => 0.01}
  validates :title, uniqueness: true
  validates :image_url, format: {
    :with => %r{\.(gif|jpg|png)}i,
    :message => 'must be a URL for GIF, JPG or PNG image.'
  }
end
```

验证的格式如下

```ruby
validate [属性名], [验证内容]
```

具体的验证内容有

- `presence`
- `numericality`
- `uniqueness`
- `uniqueness`

### 5.1.7 路由设置

为了更好的展示产品（而不是需要通过 `get` 路由访问产品列表），我们可以另外再从用户的角度完善一个页面，这需要借助一个一个新的控制器（在后面的开发中，它被定义为“付费购买用户所使用的控制器”），在终端输入

```shell
rails generate controller Store index
```

它的意思是生成一个叫做 `Store` 的控制器，同时只有一个 `index` 动作。

然后我们希望当访问根目录的时候，可以访问到 `Store#index` 对应的界面，所以我们在 `router.rb` 中加上这句话

```ruby
root 'store#index', as: 'store_index'
```

至于这个是怎么来的，可以这样理解，在路由中，标准写法是这样的

```ruby
get '/test/:id', to: 'test#test', as 'test_test'
```

这个意思是，用户用 `get` 的方式访问 `test/:id` 这个 ulr 的时候，实际访问的是 `Test` 控制器对应的 `test` 动作对应的 `view` 。当我们有了 `as` 之后，我们可以通过 `test_test_path` 来指代 `xxxx/test/:id` ，用 `test_test_url` 指代 `http:/xxxx/test/:id`。也就是说path 类方法是对应的路径，不带协议部分。url 生成的带 http。两者差别在此。

这样看上面的 `root` ，只是某种意义的简写。

我们常见的

```ruby
resoureces: products
```

其实就是一堆标准格式的声明，如下所示

| **HTTP Verb** | Path               | **Action** | **Used for**                                   |
| ------------- | ------------------ | ---------- | ---------------------------------------------- |
| GET           | /products          | index      | display a list of all products                 |
| GET           | /products/new      | new        | return an HTML form for creating a new product |
| POST          | /products          | create     | create a new product                           |
| GET           | /products/:id      | show       | display a specific product                     |
| GET           | /products/:id/edit | edit       | return an HTML form for editing a product      |
| PATCH/PUT     | /products/:id      | update     | update a specific product                      |
| DELETE        | /products/:id      | destroy    | delete a specific product                      |

其中 `PATCH, PUT, POST` 都会被转换成 `POST`

- PATCH： 实体中包含一个表，表中说明与该URI所表示的原内容的区别
- PUT：上传资源
- DELETE：删除资源

### 5.1.8 美化商品目录

在 `store#index` 中补充如下代码，表示按字典序展示所有的 `Product`

```ruby
class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
  end
end
```

同时调整相应的视图

```html
<p id="notice"><%= notice %></p>

<h1>Your Pragmatic Catalog</h1>

<% @products.each do |product| %>
  <div class="entry">
    <%= image_tag(product.image_url) %>
    <h3><%= product.title %></h3>
    <%= sanitize(product.description) %>
    <div class="price_line">
      <span class="price">
        <%= number_to_currency(product.price) %>
      </span>
    </div>
  </div>
<% end %>
```

相应的 scss 表

```scss
.store {
  h1 {
    margin: 0;
    padding-bottom: 0.5em;
    font: 150% Sans-Serif;
    color: #226;
    border-bottom: 3px dotted #77d;
  }

  .entry {
    overflow: auto;
    margin-top: 1em;
    border-bottom: 1px dotted #77d;
    height: 100px;
  }

  img {
    width: 80px;
    margin-right: 5px;
    margin-bottom: 5px;
    height: 100px;
    position: absolute;
  }

  h3 {
    font-size: 120%;
    font-family: sans-serif;
    margin-left: 100px;
    margin-top: 0;
    margin-bottom: 2px;
    color: #277;
  }

  p, div.price_line {
    margin-left: 100px;
    margin-top: 0.5em;
    margin-bottom: 0.8em;
  }

  .price {
    color: #44a;
    font-weight: bold;
    margin-right: 3em;
  }
}
```

### 5.1.9 页面布局

修改 `layouts/application.html.erb` 加入侧边栏和顶栏

```html
<!DOCTYPE html>
<html>
<head>
  <title>Pragprog Books Online Store</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <%= csrf_meta_tags %>
  <%= csp_meta_tag %>

  <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
  <%= javascript_importmap_tags %>
</head>

<body class='<%= controller.controller_name %>'>
<div id="banner">
  <span class="title"><%= @page_title %></span>
</div>
<div id="columns">
  <div id="side">
    <ul>
      <li><a href="#">Home</a></li>
      <li><a href="#">Question</a></li>
      <li><a href="#">News</a></li>
      <li><a href="#">Contact</a></li>
    </ul>
  </div>
  <div id="main">
    <%= yield %>
  </div>
</div>
</body>
</html>
```

同时修改 `scss` 文件

```scss
body, body > p, body > ol, body > ul, body > td {
  margin: 8px !important;
}

#banner {
  position: relative;
  min-height: 40px;
  background: #9c9;
  padding: 10px;
  border-bottom: 2px solid;
  font: small-caps 40px/40px "Times New Roman", serif;
  color: #282;
  text-align: center;

  img {
    position: absolute;
    top: 5px;
    left: 5px;
    width: 60px;
    height: 60px;
  }
}

#notice {
  color: #000 !important;
  border: 2px solid red;
  padding: 1em;
  margin-bottom: 2em;
  background-color: #f0f0f0;
  font: bold smaller sans-serif;
}

#notice:empty {
  display: none;
}

#columns {
  background: #141;
  display: flex;

  #main {
    padding: 1em;
    background: white;
    flex: 1;
  }

  #side {
    padding: 1em 2em;
    background: #141;

    ul {
      padding: 0;

      li {
        list-style: none;

        a {
          color: #bfb;
          font-size: small;
        }
      }
    }
  }
}

@media all and (max-width: 800px) {
  #columns {
    flex-direction: column-reverse;
  }
}

@media all and (max-width: 500px) {
  #banner {
    height: 1em;
  }
  #banner .title {
    display: none;
  }
}
```



---



## 5.2 购物车 Cart

### 5.2.1 Cart 模型

创建购物车

```shell
rails generate scaffold Cart
rake db:migrate
```

可以看到 `Cart` 基本上没有任何属性，这是因为当前开发的时候我们还不需要它们。

### 5.2.2 LineItem 商品模型

我们称在购物车中东西为“商品”，与之对应的还有“产品 Product”，两者的区别是 Product 具有某种静态的属性，没有办法说“两种香皂”，但是很容易形容“两个香皂”。`LineItem` 依附 `Product` 存在，同时也依附 `Cart`。

所以我们这样定义它

```shell
rails generate scaffold LineItem product:references cart:belongs_to
rake db:migrate
```

这种定义方式会在模型层自动生成如下代码

```ruby
class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
end
```

同时我们还需要在 `Cart` 和 `Product` 处进一步完善这种关系

```ruby
class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
end
```

其中的 `dependent: :destroy` 表示当 `Cart` 销毁的时候，其中的 `LineItem` 都会被销毁。

```ruby
# 与 line_item 关系
has_many :line_items
before_destroy :ensure_not_referenced_by_any_line_item

private
def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
    end
end
```

这里说的是，在 `Product` 被销毁前，必须执行 `ensure_not_referenced_by_any_line_item`  这个方法，这个方法检测如果没有商品关联，才可以删除，否则报错。

我们可以对这个功能进行测试，有

```ruby
test "can't delete product in cart" do
  assert_difference('Product.count', 0) do
    delete product_url(products(:two))
  end
end
```

### 5.2.3 会话

出于一些原因，我们需要在会话中保存 `cart_id`，用户每添加一个商品，我们需要从会话中把 `cart_id` 取出来，然后通过标识符在数据库中查找购物车。

我们在 `app/controllers/concerns/current_cart.rb` 中写入如下代码

```ruby
module CurrentCart
  
  private
    # 用 session 中的 cart_id 去查找 cart，如果没有找到，就创建一个新的 cart，并在 session 中存储 cart_id
    def set_cart
      @cart = Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
end
```

 `app/controllers/concerns/` 这个文件夹中一般来说是一些独立的逻辑模块或者是重复使用的功能模块，这样可以提升代码的可读性以及维护性。

### 5.2.4 “加入购物车”

我们可以将某个 `Product` 加入某个 `Cart` ，其本质是利用 `Product` 产生一个 `LineItem`。

所以需要现在商品目录加上这个按钮，最终达到调用 `LineItem#create` 的目的。

```html
<div class="price_line">
    <!-- 显示价格 -->
    <span class="price"><%= number_to_currency(product.price) %></span>
    <!-- 加入购物车 -->
    <%= button_to 'Add to Cart', line_items_path(product_id: product) %>
</div>
```

其中

```ruby
line_items_path(product_id: product)
```

就是调用 `LineItem` 创建方法 `create` 的意思，同时给它传参 `product_id`

然后我们来完善 `LineItem` 的 `create` 方法。

首先在 `LintItemController.rb` 中引入 `CurrentCart` 模块，并且在每次的 `create` 方法前都调用 `:set_cart` 方法

```ruby
class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
```

因为在 `:set_cart` 中会对 `@cart` 赋值，让其为当前对话 `session` 独有的 `cart`，所以最终的效果就是 `LineItem` 创建前就有一个 `@cart` 属性了。

然后修改 `create` 方法

```ruby
# POST /line_items or /line_items.json
  def create
    # 根据传入的 product_id 查找 product
    product = Product.find(params[:product_id])
    # build 方法与 new 方法类似，会创建一个与 @cart 和 product 都相关的 @line_item
    @line_item = @cart.line_items.build(product: product)

    respond_to do |format|
      if @line_item.save
        # 跳转的对象不再是 @line_item，而是它的购物车
        format.html { redirect_to @line_item.cart, notice: "Line item was successfully created." }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
```

最后修改 `cart` 的 `show` 页面，让其可以显示里面的 LineItem。

```html
<p id="notice"><%= notice %></p>

<h2>Your Pragmatic Cart</h2>

<ul>
  <% @cart.line_items.each do |item| %>
    <li><%= item.product.title %></li>
  <% end %>
</ul>
```

### 5.2.5 加入数量

对于一个商品来说，之前的设计是有问题的，比如说我们买了两个香皂，那么不应该是“香皂，香皂”的显示两遍，而是应该“2 x 香皂”这样的显示，所以对于 `LineItem` 来说，数量是极其必要的。

所以创建迁移

```shell
rails generate migration add_quantity_to_line_items quantity:integer
```

但是还需要接着修改这个迁移，因为要设置其默认值为 1

```ruby
class AddQuantityToLineItems < ActiveRecord::Migration[7.0]
  def change
    # 默认值是 1
    add_column :line_items, :quantity, :integer, default: 1
  end
end
```

然后需要修改 `add_cart` 的行为，并不是每次“加入购物车”，都是会产生一个新的 `LineItem` 的。首先在 `app/models/cart.rb` 中加入方法

```ruby
def add_product(product)
    # 根据 product_id 查找 current_item
    current_item = line_items.find_by(product: product.id)

    if current_item
        # 查找到了，就数量增加 1
        current_item.quantity += 1
    else
        # 没查找到，就创建 line_item
        current_item = line_items.build(product_id: product.id)
    end
    # 返回 current_item
    current_item
end
```

然后修改 `line_item#create`

```ruby
@line_item = @cart.add_product(product)
```

同时为了让已有的 `LineItem` 数据依然显示正确，需要创建一个迁移进行修改

```shell
rails generate migration combine_items_in_cart
```

这个迁移没法按照“约定”自动产生 `change`，所以需要自己手写 `up, down`（这两个方法似乎也是某种约定）

```ruby
class CombineItemsInCart < ActiveRecord::Migration[7.0]
  def up
    Cart.all.each do |cart|
      # 把购物车中同一个产品的多个商品替换为单个商品
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # 删除同一个产品的多个商品
          cart.line_items.where(product_id: product_id).delete_all

          # 替换为单个商品
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
    LineItem.where("quantity>1").each do |line_item|
      line_item.quantity.times do
        LineItem.create(
          cart_id: line_item.cart_id,
          product_id: line_item.product_id,
          quantity: 1
        )
      end
      line_item.destroy
    end
  end
end
```

### 5.2.6 清空购物车

清空购物车的本质是将当前的购物车删除，所以先加入“清空按钮”在 `show.html` 中

```html
<p id="notice"><%= notice %></p>

<h2>Your Cart</h2>

<!-- 购物清单 -->
<table>
  <% @cart.line_items.each do |item| %>
    <tr>
      <td><%= item.quantity %> &times; </td>
      <td><%= item.product.title %></td>
      <td class="item_price"><%= number_to_currency(item.total_price) %></td>
    </tr>
  <% end %>
  <!-- 总金额 -->
  <tr class="total_line">
    <td colspan="2">Total</td>
    <td class="total_cell"><%= number_to_currency(@cart.total_price) %></td>
  </tr>
</table>

<!-- 清空购物车 -->
<%= button_to 'Empty Cart', @cart, method: :delete, data: {confirm: 'Are you sure?'} %>
```

并且补充相应的方法即可。

### 5.2.7 局部渲染

我们希望在侧边栏也有购物车信息，所以我们考虑利用局部渲染。具体的知识在前面有，所以按照递归的思路，我们需要在 `application.html.erb` 中加入购物车

```html
<div id="cart">
   <%= render @cart %>
</div>
```

这个东西会去渲染 `_cart.html.erb` 文件，所以需要将它的内容改得和 `carts/show.html.erb` 一样

```html
<h2>Your Cart</h2>

<!-- 购物清单 -->
<table>
  <%= render(cart.line_items) %>
  <!-- 总金额 -->
  <tr class="total_line">
    <td colspan="2">Total</td>
    <td class="total_cell"><%= number_to_currency(cart.total_price) %></td>
  </tr>
</table>

<!-- 清空购物车 -->
<%= button_to 'Empty Cart', @cart, method: :delete, data: {confirm: 'Are you sure?'} %>

```

这里面有一个

```html
<%= render(cart.line_items) %>
```

这是因为对于 `line_items` 的渲染，在 `cart_html.erb` 中也出现了。这种局部渲染是一种集合渲染，所以渲染的模板在 `_line_item.html.erb` 中，修改如下

```html
<tr>
  <td><%= line_item.quantity %> &times; </td>
  <td><%= line_item.product.title %></td>
  <td class="item_price"><%= number_to_currency(line_item.total_price) %></td>
</tr>
```

最终意识到其实没有必要对 `carts/show.html.erb` 重复内容，所以将其改为

```html
<p id="notice"><%= notice %></p>

<%= render @cart %>
```

因为在侧边栏中现在也有了 `cart` ，所以同样需要 `set_cart` ，所以对于 `StoreController` 中加入如下代码

```ruby
class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart

  def index
    @products = Product.order(:title)
  end
end
```

### 5.2.8 Ajax 购物车

现在每次进行 `Add Cart` 操作，本质都是在渲染整个 `application.html.erb` 页面，这无疑是低效的，所以考虑只渲染侧边栏的购物车部分。

首先需要在 `Add Cart` 按钮上添加 `remote` 参数

```html
<%= button_to 'Add to Cart', line_items_path(product_id: product), remote:true %>
```

然后在 `create` 方法上加入神秘的 `format.js` ，我暂时还理解不了为啥，可以理解为启用了 js 脚本

```ruby
# POST /line_items or /line_items.json
  def create
    # 根据传入的 product_id 查找 product
    product = Product.find(params[:product_id])
    # build 方法与 new 方法类似，会创建一个与 @cart 和 product 都相关的 @line_item
    @line_item = @cart.add_product(product)

    # respond_to 是一个方法，其参数为一个 block
    # 我现在的理解是 respond_to 描述的是服务器对于客户端的反应，或者说，这是浏览器上将执行的步骤
    # 这里就是先对于 html 进行一个重定向操作，然后调用 js，最后 json
    respond_to do |format|
      if @line_item.save
        # 跳转的对象不再是 @line_item，而是 store 页面
        format.html { redirect_to store_index_url }
        # 调用 js 脚本
        format.js
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
```

然后就会调用 `views/line_items/create.js.erb` 这个文件，将这个文件写入以下内容

```javascript
$('#cart').html("<%= j render(@cart) %>")
```

这个脚本描述了将 `id = cart` 的节点替换成 `render(@cart)` 的操作。

### 5.2.9 突出显示

为了增强美工性，考虑引入 `jQuery-ui`。

`jQuery` 是 `JavaScript` 的一个好用的库，里面有常见的 html 操作和一组简单的 UI，我们需要更改 `Gemfile` 来安装它

```ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
```

然后执行

```shell
bundle install
```

然后新建 `app/assets/javascripts/application.js` 内容为

```javascript
//= require jquery
//= require jquery_ujs
//= require jquery-ui/effect.all
//= require_tree .
```

至于为啥是这个，并不知道为啥。这样之后我们就可以使用 `jquery-ui` 了。

然后考虑如何对“刚刚点击过”的 `LineItem` 做一个突出显示，可以考虑在 `create` 中维护一个 `@current_item`

```ruby
format.js { @current_item = @line_item }
```

然后在 `_line_item.html.erb` 中，将 `current` 标出来

```html
<% if line_item == @current_item %>
  <tr id="current_item">
<% else %>
  <tr>
<% end %>
    <td><%= line_item.quantity %> &times;</td>
    <td><%= line_item.product.title %></td>
    <td class="item_price"><%= number_to_currency(line_item.total_price) %></td>
  </tr>
```

然后在 `create.js.erb` 中进行渲染

```js
$('#current_item').css({'background-color': '#88ff88'}).
                  animate({'background-color': '#114411'}, 1000)
```

### 5.2.10 辅助方法

我们希望可以在购物车内商品数量为 0 的时候，不显示购物车。

可以利用购物车长度作为判断，这里我们用到了辅助方法（主要是为了让代码更加整洁）

```html
<!-- 购物车 -->
<div id="cart">
  <% if @cart %>
    <%= hidden_div_if(@cart.line_items.empty?, id: 'cart') do %>
      <%= render @cart %>
    <% end %>
  <% end %>
</div>
```

辅助方法为在 `app/helpers` 下的方法，脚手架会自动帮我们建好这些文件。

```ruby
module ApplicationHelper
  def hidden_div_if(condition, attributes={}, &block)
    # 将 html 中具有 attributes 并满足 condition 条件的 div 设置为 display: none
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end
end
```

同时我们需要修改 js 文件，使得购物车显示的时候比较平滑

```js
if ($('#cart tr').length === 1) { $('cart').show('blind', 1000) }
```



---



## 5.3 订单 Order

### 5.3.1 Order 模型

订单模型本质上信息全都是收货的信息，订单具体有什么商品，其实并不是由 Order 决定的，而是由 LineItem 决定的。因此建立如下如下模型

```shell
rails generate scaffold Order name address:text email phone pay_type:integer
```

同时给 `LineItem` 添加外键

```shell
rails generate migration add_order_to_line_item order:references 
```

最后融合迁移

```shell
rails db:migrate
```

然后就会发现融合不了，这是因为对于 LineItem，他有三个外键，分别是 `Product, Cart, Order` ，在迁移中自动生成的外键，都是不允许为空的，而现在，对于一个 `LineItem` ，它要么在 `Cart` 中，要么在 `Order` 中，所以总会有一个外键为空，所以需要修改多处地方。

首先要修改 `LineItem` 的两个 migration

```ruby
# 20230101081559_create_line_items.rb
class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.references :product, null: false, foreign_key: true
      t.belongs_to :cart, null: true, foreign_key: true

      t.timestamps
    end
  end
end

# 20230102121647_add_order_to_line_item.rb
class AddOrderToLineItem < ActiveRecord::Migration[7.0]
  def change
    add_reference :line_items, :order, null: true , foreign_key: true
  end
end
```

 然后还要在 `model` 中进行数据关系的定义

```ruby
class LineItem < ApplicationRecord
  belongs_to :product
  # optional 表示外键可以为空
  belongs_to :cart, optional: true
  belongs_to :order, optional: true

  def total_price
    product.price * quantity
  end
end

class Order < ApplicationRecord
  enum pay_type: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2
  }

  has_many :line_items, dependent: :destroy
end
```

### 5.3.2 生成订单

生成订单的过程是一个将购物车中所有的 `LineItem` 都放到 `Order` 中的一个过程，我们可以用一个方法描述这个过程，定义在 `model` 中。

```ruby
class Order < ApplicationRecord
  enum pay_type: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2
  }

  has_many :line_items, dependent: :destroy

  validates :name, :address, :email, :phone, presence: true
  validates :pay_type, inclusion: pay_types.keys

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
```

可以看到还新增了一些字段的验证约束，然后考虑生成表格，首先在 `_cart.html.erb` 加上生成 `Order` 的按钮

```html
<!-- 结算购物车 -->
<%= button_to 'Checkout', new_order_path, method: :get %>
```

这个方法会调用 `new` 方法，所以我们需要写一下 `new.html.erb` 这个模板

```html
<div class="project_form">
  <fieldset>
    <h2>Please Enter Your Details</h2>
    <%= render 'form', order: @order %>
  </fieldset>
</div>
```

还有与之相关的 `_form.html.erb`

```html
<%= form_with(model: order) do |form| %>
  <% if order.errors.any? %>
    <div style="color: red">
      <h2><%= pluralize(order.errors.count, "error") %> prohibited this order from being saved:</h2>

      <ul>
        <% order.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div>
    <%= form.label :name, style: "display: block" %>
    <%= form.text_field :name, size: 40 %>
  </div>

  <div>
    <%= form.label :address, style: "display: block" %>
    <%= form.text_area :address, rows: 3, cols: 37 %>
  </div>

  <div>
    <%= form.label :email, style: "display: block" %>
    <%= form.text_field :email, size: 40 %>
  </div>

  <div>
    <%= form.label :phone, style: "display: block" %>
    <%= form.text_field :phone, size: 40 %>
  </div>

  <div>
    <%= form.label :pay_type, style: "display: block" %>
    <%= form.select :pay_type, Order.pay_types.keys, prompt: 'Select a payment method' %>
  </div>

  <div class="actions">
    <%= form.submit 'Place Order'%>
  </div>
<% end %>
```

并且美化样式

```scss
.project_form {
  fieldset {
    background: #efe;

    h2 {
      color: #dfd;
      background: #141;
      font-family: sans-serif;
      padding: 0.2em 1em;
    }

    div {
      margin-bottom: 0.3em;
    }
  }

  form {
    label {
      width: 5em;
      float: left;
      text-align: right;
      padding-top: 0.2em;
      margin-right: 0.1em;
      display: block;
    }

    select, textarea, input {
      margin-left: 0.5em;
    }

    .submit {
      margin-left: 4em;
    }

    br {
      display: none;
    }
  }
}
```

在 `Order#create` 的过程中，需要清空购物车，所以需要修改一下 `create` 方法

```ruby
# POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        # 清空购物车
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        
        format.html { redirect_to store_index_url(@order), notice: "Thank you for your order." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
```

### 5.3.3 订单展示

作为管理端，需要看到所有的订单，所以考虑修改 `index.html.erb` 这个模板，将其改成表格形式会更漂亮一些，同时加上一些操作和跳转。

```html
<%= form_with(model: order) do |form| %>
  <% if order.errors.any? %>
    <div style="color: red">
      <h2><%= pluralize(order.errors.count, "error") %> prohibited this order from being saved:</h2>

      <ul>
        <% order.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div>
    <%= form.label :name, style: "display: block" %>
    <%= form.text_field :name, size: 40 %>
  </div>

  <div>
    <%= form.label :address, style: "display: block" %>
    <%= form.text_area :address, rows: 3, cols: 37 %>
  </div>

  <div>
    <%= form.label :email, style: "display: block" %>
    <%= form.text_field :email, size: 40 %>
  </div>

  <div>
    <%= form.label :phone, style: "display: block" %>
    <%= form.text_field :phone, size: 40 %>
  </div>

  <div>
    <%= form.label :pay_type, style: "display: block" %>
    <%= form.select :pay_type, Order.pay_types.keys, prompt: 'Select a payment method' %>
  </div>

  <div class="actions">
    <%= form.submit 'Place Order'%>
  </div>
<% end %>
```

对于订单的详情展示，可以仿照 `_cart.html.erb` 书写

```html
<table>
  <%= render(order.line_items) %>
  <!-- 总金额 -->
  <tr class="total_line">
    <td colspan="2">Total</td>
    <td class="total_cell"><%= number_to_currency(order.total_price) %></td>
  </tr>
</table>
```



---



## 5.4 用户 User

### 5.4.1 User 模型

考虑用户具有用户名，密码，角色三个属性，模型如下

```shell
rails generate scaffold User name:string password:digest role:integer
rails db:migrate
```

对于密码部分，可以借助插件完成“确认密码的功能”

```ruby
class User < ApplicationRecord
  has_secure_password
end
```

同时在 `gemfile` 中填入这个插件

```ruby
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"
```

然后使用 

```
bundle install
```

同时还有关于 `role` 的设计，目前有两个角色，一个是 `Buyer`，一个是 `Admin`，其中 `Admin` 的权限更高。

```ruby
class User < ApplicationRecord
  enum role: {
    "Buyer" => 0,
    "Admin" => 1
  }

  validates :name, presence: true, uniqueness: true
  validates :role, presence: true
  validates :role, inclusion: roles.keys
  
  has_secure_password
end
```

注意如果希望 `role` 作为一个枚举变量，那么这里一定要定义 `enum` 的名字为 `role`，不能叫 `role_type` 或者其他任何的名字，都不会让其具有枚举的效果，这大概就是神秘的 rails 吧。

### 5.4.2 控制器与页面

身份验证就是登录相关的功能，这里需要新建两个控制器，`sessions` 用于为登录和登出提供支持，`admin` 用于为管理员提供欢迎界面。

其中 `sessions` 只有两个动作，`new, create` 对应登入，`destroy` 对应登出

```
rails generate controller Sessions new create destroy 
```

`Admin` 只有一个动作 `index`，代表欢迎界面。

```shell
rails generate controller Admin index
```

这也启发我，其实写一个页面就是写一个 controller 和一个 view 而已，这是因为 view 似乎没有办法单独成为一个路由资源。

### 5.4.3 登录登出

登入功能就是填一个表单，所以在 `new.html.erb` 中写入

```html
<div class="project_form">
  <% if flash[:alert] %>
    <p id='notice'><%= flash[:alert] %></p>
  <% end %>

  <%= form_tag do %>
    <fieldset>
      <legend>Please Log In</legend>
      <div>
        <%= label_tag :name, 'Name:' %>
        <%=text_field_tag :name, params[:name] %>
      </div>

      <div>
        <%= label_tag :password, 'Password:' %>
        <%= password_field_tag :password, params[:password] %>
      </div>

      <div>
        <%= submit_tag 'Login' %>
      </div>
    </fieldset>
  <% end %> %>
</div>
```

可以看到，因为 `Sessions` 并没有与模型关联，所以我们并没有用 `form_for` ，只是一个普通的 `form_tag`。收集的信息进入了 `params`。

然后我们在 `create` 中利用 `params` 中的信息保存到 `session` 中

```ruby
  def create
    # 这里更加明显，create 会有一个 params，params 的来历就是 new 填的表单
    user = User.find_by(name: params[:name])
    # try 对于为 nil 的 user，会直接进入 else
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      session[:user_role] = user.role
      # 如果是 Buyer ，就定向到商店，否则定向到 admin 的欢迎界面
      if user.role == "Buyer"
        redirect_to store_index_url
      else
        redirect_to admin_url
      end
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end
```

同时完成相应界面的跳转，我们在 `session` 中保存了用户的 `id` 和权限信息。

退出登录的状态就很简单，就是将 session 中的信息注销掉即可

```ruby
  def destroy
    session[:user_id] = nil
    session[:user_role] = nil
    redirect_to store_index_url, notice: "Logged out"
  end
```

对于管理界面，可以自己设计一个

```html
<h1>Welcome</h1>

<div>
  It's <%= Time.now %>
  We hava <%= pluralize(@total_orders, 'order') %>
</div>
```

最后需要修改路由

```ruby
  get 'admin' => 'admin#index'
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
```

### 5.4.4 访问限制

访问限制可以在 `application_controller.rb` 中利用 `before_action` 实现

```ruby
class ApplicationController < ActionController::Base
  before_action :authorize

  protected
  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Pleas log in."
    end
  end
end
```

然后在各个控制器，选择是否跳过 `authorize` 即可

```ruby
class SessionsController < ApplicationController
  skip_before_action :authorize
```

这时会发现所有的 test 基本上都瘫痪了，这是因为 test 不会自动登录，所有在 `test/test_helper.rb` 中写入如下代码即可

```ruby
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
class ActionDispatch::IntegrationTest
  def login_as(user)
    post login_url, params: {name: user.name, password: 'secret'}
  end

  def logout
    delete logout_url
  end

  def setup
    login_as(users(:one))
  end
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
```

### 5.4.5 权限显示

我们希望对于管理者，可以看到更多的界面，而对于非管理者，则不需要看到这些界面

```html
	  <!-- 管理链接 -->
      <% if current_user and current_user.role == 'Admin' %>
        <ul>
          <li><%= link_to 'Orders', orders_path %></li>
          <li><%= link_to 'Products', products_path %></li>
          <li><%= link_to 'Users', users_path %></li>
        </ul>
      <% end %>
      <!-- 登录登出 -->
      <div class="log">
        <% if current_user %>
          <%= current_user.name %> Logged in.<br/>
          <%= link_to 'Logout', logout_path, method: :delete %>
        <% else %>
          Please <%= link_to 'Login', login_url %>
        <% end %>
      </div>
```

这些需要借助 `current_user` 这个方法，这个方法定义在 `application_controller.rb` 中

```ruby
helper_method :current_user

def current_user
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end
```



----



## 5.5 收藏夹 Favourite

### 5.5.1 Favourite 模型

每个用户都有一个收藏夹，二者是一对一关系，所以没有必要单独做一个实体，可以直接使用 `User` 模型。但是在实际思考的时候，却应当有收藏夹这个模型，比较方便思考。

### 5.5.2 FavorItem 收藏品模型

收藏品模型描述的是 `Product` 和 `Favourite` 之间的“多对多关系”，所以需要这样建立模型

```
rails generate scaffold FavorItem product:references user:belongs_to
rake db:migrate
```

对于 `User` 模型，补充如下代码，也就是当 User 持有一个 `favor_items` 集合，同时当 `User` 销毁的时候，会销毁所有的 `favor_items` 。

```ruby
has_many :favor_items, dependent: :destroy
```

对于 `Product` 模型，补充如下代码，同样 `Product` 持有一个 `favor_item` 集合，同时在销毁前要检验是否可以销毁。

```ruby
  has_many :favor_items
  before_destroy :ensure_not_referenced_by_any_favor_item
  def ensure_not_referenced_by_any_favor_item
    unless favor_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort
    end
  end
```

### 5.5.3 加入收藏夹

在 `store` 界面上，除了有“加入购物车”之外，应当有“加入收藏夹”的功能，可以如此修改 `store` 界面

```html
<!-- 加入收藏夹 -->
<%= button_to 'Add to Favourite', favor_items_path(product_id: product) %>
```

可以看到需要修改 `favor_item` 的 `create` 方法

```ruby
  def create
    # 根据传入的 product_id 查找 product
    product = Product.find(params[:product_id])
    @favor_item = @user.add_product(product)

    respond_to do |format|
      if @favor_item.save
        format.html { redirect_to store_index_url }
        format.json { render :show, status: :created, location: @favor_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @favor_item.errors, status: :unprocessable_entity }
      end
    end
  end
```

可以看到需要获得一个收藏夹的 `@user`，与 `@cart` 类似，所以需要一个 `set_user` 的过程

```ruby
    def set_user
      @user = User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to store_index_url
    end
```

### 5.5.4 收藏夹展示

类似于一个产品目录的子集，可以写 `index.html.erb` 

```html
<p style="color: green"><%= notice %></p>

<h1>Favourite Collections</h1>

<div id="favor_items">
  <table>
  <% @favor_items.each do |favor_item| %>
    <%= render favor_item %>
  <% end %>
  </table>
</div>
```

可以看到除了外面套了一个表之外，主体是对于每个 `favor_item` 的渲染，所以需要修改 `_favor_item.html.erb` 

```html
<tr class="<%= cycle('list_line_odd', 'list_line_even') %>">
  <td>
    <%= image_tag(favor_item.product.image_url, class: 'list_image') %>
  </td>

  <td class="list_description">
    <dl>
      <dt><%= favor_item.product.title %></dt>
      <dd><%= strip_tags(favor_item.product.description) %></dd>
    </dl>
  </td>

  <td>
    <dl>
      <%= number_to_currency(favor_item.product.price) %>
    </dl>
    <dl>
      <%= button_to 'Add to Cart', line_items_path(product_id: favor_item.product), remote:true %>
    </dl>
    <dl>
      <%= button_to 'Remove', favor_item, :method => :delete %>
    </dl>
  </td>
</tr>
```

---



## 5.6 促销活动 Activity

### 5.6.1 Activity 模型

促销活动只有一个属性就是名字，具体的促销也在这里体现体现，所以应当在终端中输入如下示例

```shell
rails generate scaffold Activity name:string disconut:integer
rake db:migrate
```

### 5.6.2 Prompt 促销项模型

促销项都是外键，用于关联 `Product` 产品和 `Activity` 活动，形成“活动-产品” 的多对多关系。

```shell
rails generate scaffold Prompt  product:references activity:belongs_to
rake db:migrate
```

同时完善 `Product` 模型

```ruby
has_many :prompts, dependent: :destroy
```

和 `Activity` 模型

```ruby
has_many :prompts, dependent: :destroy
```

### 5.6.3 新建活动

一个活动由本身和它包括的商品组成，在创建的时候，可以先创建好活动，确定活动的名称和折扣力度，然后再向这个活动添加涉及的商品。创建活动这个操作只有管理员可以干，所以我们用一个管理链接指向 `activities` 的展示页面

```html
<li><%= link_to 'Prompt', activities_path %></li>
```

然后对于这个页面，我们只是展示其名称和折扣

```html
<p style="color: green"><%= notice %></p>

<h1>Activities</h1>

<div id="activities">
  <% @activities.each do |activity| %>
    <span>
      Name:
      <%= activity.name %>
    </span>
    <spac>
      Discount:
      <%= number_to_percentage(activity.discount, precision: 0) %>
    </spac>

    <p>
      <%= link_to "Show this activity", activity %>
    </p>
  <% end %>
</div>

<%= link_to "New activity", new_activity_path %>
```

在活动中添加商品的操作，可以考虑在具体的活动界面进行添加，也就是 `_activity.html.erb` 中添加

```html
<div id="<%= dom_id activity %>">
  <!-- 活动的基本信息 -->
  <div>
    <strong>Name:</strong>
    <%= activity.name %>
  </div>
  <div>
    <strong>Discount:</strong>
    <%= number_to_percentage(activity.discount, precision: 0) %>
  </div>
  
  <!-- 这里展示了产品列表，可以将产品添加到活动中 -->
  <% Product.all.each do |product| %>
      <div class="entry">
        <h3><%= product.title %></h3>
        <div class="price_line">
          <!-- 加入活动 -->
          <%= button_to 'Add to Activity', prompts_path(product_id: product, activity_id: activity)%>
        </div>
      </div>
  <% end %>
  
  <!-- 已经加入活动的产品 -->
  <% activity.prompts.each do |prompt| %>
    <div>
      <%= prompt.product.title %>
    </div>
  <% end %>
</div>
```

对于创建一个 `prompt`，与以往不同，需要传入两个参数，也就是 `prompt` 的两端 `product` 和 `activity`，也就是这样

```html
<!-- 加入活动 -->
<%= button_to 'Add to Activity', prompts_path(product_id: product, activity_id: activity)%>
```

所以需要修改 `prompt` 的 `create` 方法

```ruby
  # POST /prompts or /prompts.json
  def create
    # 根据传入的 product_id 查找 product
    product = Product.find(params[:product_id])
    activity = Activity.find(params[:activity_id])
    @prompt = activity.add_product(product)

    respond_to do |format|
      if @prompt.save
        format.html { redirect_to activity_url(activity), notice: "Prompt was successfully created." }
        format.json { render :show, status: :created, location: @prompt }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prompt.errors, status: :unprocessable_entity }
      end
    end
  end
```

可以看到进行了两次查找，最终利用两次查找的信息建立了 `prompt`。和 `favor_item` 的 `add_product` 一致，对于加入活动的产品，只能加入一次

```ruby
  def add_product(product)
    # 根据 product_id 查找 current_item
    current_item = prompts.find_by(product: product.id)

    if current_item
      # 查找到了，就啥都不干
    else
      # 没查找到，就创建 prompt
      current_item = prompts.build(product_id: product.id)
    end
    # 返回 current_item
    current_item
  end
```

### 5.6.4 实现折扣

促销大概需要两个两个机制

- 在 `store` 界面上展示折扣
- 在加入购物车或者订单的时候实际发生折扣

展示折扣这个功能很好实现，只需要在 `store` 界面中利用 `product` 检索 `prompt` 进而检索 `activity.discount` 即可。

```html
<!-- 显示折扣 -->
<% product.prompts.each do |prompt| %>
    <span> &times; <%= number_to_percentage(prompt.activity.discount, precision: 0) %></span>
<% end %>
```

注意这里用到了 `number_to_percentage` 方法，可以将普通整数转换成百分制（除以 100 加百分号）。

发生实际折扣，需要更改 `price` 的计算方式，原来对于价格的计算，是 `Cart` 或者 `Order` 对于其所有的 `item` 的 `price` 进行求和，`line_item` 的价格计算，是 `Product.price` 和 `quantity` 的乘积，如下所示

```ruby
def total_price
  product.price * quantity
end
```

可见，只要修改 `price` 即可，所以在 `product` 中新写一个方法去获得折扣价格

```ruby
  def getDiscountPrice
    discount = price
    prompts.each do |prompt|
      discount *= (prompt.activity.discount / 100.0)
    end
    discount
  end
```

然后修改 `total_price` 为

```ruby
  def total_price
    product.getDiscountPrice * quantity
  end
```

即可。

### 5.6.5 展示折扣

对于普通用户来说，没有权限建立活动，但是有权限浏览活动，所以可以实现一个活动界面用于浏览，但是考虑到 `index.html.erb` 已经用于给管理者新建活动使用了，所以考虑新开设一个界面，在控制器中新定义一个方法

```ruby
  def show_activity
    @show_activities = Activity.all
  end
```

然后建立对应的 `show_activity.html.erb` 这个页面，其内容如下

```html
<div class="show_activities">
  <h1>促销活动</h1>
  <% @show_activities.each do |activity| %>
    <div class="entry">
      <div class="name">
        <%= activity.name %>
      </div>
      <div class="discount">
        折扣力度：
        <%= number_to_percentage(activity.discount, precision: 0) %>
      </div>
      <div class="items">
        促销产品：
        <% activity.prompts.each do |prompt| %>
          <span class="product"><%= prompt.product.title %>,</span>
        <% end %>
      </div>
    </div>
  <% end %>
</div>
```

其后完善链接即可。
