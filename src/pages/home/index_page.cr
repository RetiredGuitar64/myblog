class Home::IndexPage < MainLayout
  def content
    h1 do
      text "Dashboard"
      tag "sub-title" do
        text "How I Learned To Stop Worrying and Love Baz"
      end
    end

    # a class: "chip", href: "/" do
    #   img src: "profiles/jdoe.webp"
    #   text "John Doe"
    # end

    raw <<-'HEREDOC'
<ul class="nested-list">
  <li>Items
    <ul>
      <li>...</li>
      <li>...</li>
    </ul>
  <li>Widgets
    <ul>
      <li>...</li>
      <li>...</li>
    </ul>
</ul>
HEREDOC

    div id: "demo" do
    end

    raw <<-'HEREDOC'
<form class="table rows">
  <p>
      <label for=name>Name</label>
      <input type=text id=name name=name>
  </p>
  <p>
      <label for=adr>Address</label>
      <input type=text id=adr name=adr>
  </p>
</form>
HEREDOC

    raw <<-'HEREDOC'
<div class="grid grid-variable-rows">
  <div class="box info" data-cols="1 2" data-rows="1 2">Sidebar  </div>
  <div class="box info" data-cols="3 5" data-rows="1 3">Main     </div>
  <div class="box info" data-cols="6" data-rows="2" data-cols@s="3 5" data-rows@s="4">Aux</div>
</div>
HEREDOC

    para_text "字符串必须是双引号，但是也可以使用 %Q 或省略Q, 写作 % ，%q 则表示单引号"

    missing_warn "字符串必须是双引号，但是也可以使用 %Q 或省略Q, 写作 % ，%q 则表示单引号"

    missing_error "出错了！"

    missing_info "这个可以用来提示信息"

    missing_ok "废话"

    code = <<-'HEREDOC'
    h1 do
      text "Dashboard"
      tag "sub-title" do
        text "How I Learned To Stop Worrying and Love Baz"
      end
    end
HEREDOC

    raw formatter.format(code, lexer)

    figure class: "f-row justify-content:space-between" do
      button "✀", class: "iconbutton"
      button "✀", class: "iconbutton"
      button "✀", class: "iconbutton"
      button "✀", class: "iconbutton"
      button "✀", class: "iconbutton"
      button "✀", class: "iconbutton"
      button "✀", class: "iconbutton"
      button "✀", class: "iconbutton"
    end

    para "Hello, Crystal China!", class: "big"

    section class: "tool-bar margin-block" do
      button "Filter"
      button "Sort"

      hr "aria-orientation": "vertical"

      label do
        text "Search："
        input type: "text"
      end

      fieldset class: "contents" do
        label do
          text "From "
          input type: "date", value: "2022-07-11"
        end
        label do
          text "To "
          input type: "date", value: "2022-07-11"
        end
      end
    end

    div id: "content", class: "f-row flex-wrap:wrap" do
      section class: "box flex-grow:2" do
        h3 "Tests"
        para do
          text <<-'HEREDOC'
Lorem, ipsum dolor sit amet consectetur adipisicing elit. Natus, alias repellat. Totam debitis ut cupiditate odio mollitia eaque veritatis tempora? Pariatur, ipsam quasi. Quo aliquid deleniti quia rem, magnam voluptatum repudiandae officia ea. A eaque repellendus repudiandae nesciunt quis amet. Lorem ipsum dolor sit amet consectetur adipisicing elit. Ad ullam error, dicta eos laboriosam eaque fugit id at corrupti nam.
HEREDOC
        end
      end

      section class: "box flex-grow:1" do
        h3 "Executions"
        para do
          text <<-'HEREDOC'
Lorem ipsum dolor sit, amet consectetur adipisicing elit. Soluta culpa, fugit recusandae cum neque ipsum totam aliquid omnis consequatur magnam. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Harum, error.
HEREDOC
        end
      end

      section class: "box flex-grow:1" do
        h3 "Stuff"
        para do
          text <<-'HEREDOC'
Lorem ipsum dolor sit, amet consectetur adipisicing elit. Soluta culpa, fugit recusandae cum neque ipsum totam aliquid omnis consequatur magnam. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Harum, error.
HEREDOC
        end
      end

      section class: "box flex-grow:1" do
        h3 "Data"
        para do
          text <<-'HEREDOC'
Lorem ipsum dolor sit, amet consectetur adipisicing elit. Soluta culpa, fugit recusandae cum neque ipsum totam aliquid omnis consequatur magnam. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Harum, error.
HEREDOC
        end
      end

      section class: "box flex-grow:1" do
        h3 "Analytics"
        para do
          text <<-'HEREDOC'
Lorem ipsum dolor sit, amet consectetur adipisicing elit. Soluta culpa, fugit recusandae cum neque ipsum totam aliquid omnis consequatur magnam. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Harum, error.
HEREDOC
        end
      end

      section class: "box flex-grow:4" do
        h3 "Timeserious"
        para do
          text <<-'HEREDOC'
Lorem ipsum dolor, sit amet consectetur adipisicing elit. Illum quibusdam minima excepturi distinctio harum temporibus, rerum facilis, reiciendis odit quo atque nobis quidem! Praesentium est, quam explicabo exercitationem ducimus veniam quisquam dolor omnis alias et ipsa commodi voluptas consectetur sit autem blanditiis magnam animi. Vero porro expedita voluptates doloribus illum cum eius esse beatae. Itaque fuga perferendis magni porro reprehenderit quam debitis quas asperiores praesentium dolor, officia veritatis illum vitae doloribus nobis vero obcaecati suscipit incidunt, soluta nihil. Odit, atque quae? Ratione labore inventore voluptatem minima ab aperiam facilis. Similique architecto minus, soluta animi nisi nulla omnis nam et laboriosam alias obcaecati doloribus quod corporis, repellendus fugiat porro labore distinctio, quis esse. Soluta excepturi suscipit modi nemo quidem nulla rerum.
HEREDOC
        end
      end
    end
  end
end
