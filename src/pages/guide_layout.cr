abstract class GuideLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def page_title

  needs title : String
  needs guide_action : GuideAction.class
  needs markdown : String

  def page_title
    @title
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead.new(page_title: page_title, context: @context)

      body class: "font-sans text-grey-darkest leading-tight bg-grey-lighter" do
        mount Shared::Header.new(@context.request)
        middle_section
        guide_content
      end
    end
  end

  def middle_section
    div class: "bg-green-gradient" do
      div class: "flex relative py-8 pr-10 container mx-auto text-white" do
        div class: "w-sidebar ml-12"
        table_of_contents
        mount Guides::Sidebar.new(@guide_action)
      end
    end
  end

  def guide_content
    div class: "flex container mx-auto" do
      div class: "ml-sidebar pl-12 guide-content" do
        content
      end
    end
  end

  def table_of_contents
    div class: "mt-5" do
      h1 @title, class: "font-normal font-xl text-white text-shadow mb-6 tracking-medium"
      ul class: "list-reset text-shadow text-lg mb-4" do
        guide_sections.each do |section|
          li do
            link "#", class: "text-white block py-1 no-underline hover:underline" do
              span "#", class: "opacity-75 mr-2 hover:no-underline"
              text section
            end
          end
        end
      end
    end
  end

  def guide_sections
    @markdown.split("\n").select(&.starts_with?("## ")).map(&.gsub("## ", ""))
  end
end
