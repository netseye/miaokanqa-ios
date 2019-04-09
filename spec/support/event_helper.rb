require 'rubygems'
require 'appium_lib'
require 'date'
require 'logger'
require 'pathname'
require 'thread'
require 'fileutils'

#创建日志路径，打印日志
def loginfo(s = "#{$!.message} #{$@[0]} ")
    wait do
      url = file()
      #判断需写入的日志内容是否为空，如果为空则不需要写入
      return if not s
      #创建logger实例
      logger = Logger.new(url+(Time.now).strftime("%Y-%m-%d")+"_install_detail.log", 'daily') #daily/weekly/monthly.
      #赋予logger控制输出级别为DEBUG。DEBUG含义是：既可以在
      #控制台看到需写入的日志信息，又写入到了日志文件中
      logger.level = Logger::INFO
      logger.info(''){s}
      logger.close
    end
end
#清除文件内上一次创建的内容，该方法调用必须写在所有方法之前
def logdelete()
  wait do
    url = file()
    io = File.open(url+(Time.now).strftime("%Y-%m-%d")+"_install_detail.log","w")
  end
end
#创建文件夹/result/image/
def url()
  begin
    wait do
      FileUtils.makedirs(Dir.pwd+"/result/image/")
    end
  rescue =>ex
    TakeTakesScreenshot()
    raise Exception,"创建文件夹异常！#{ex.message}"
  end
end
#获取当前路径
def file()
  begin
    wait do
      Dir.pwd
    end
  rescue =>ex
    TakeTakesScreenshot()
    raise Exception,"当前路径异常!#{ex.message}"
  end
end

def click_by_button_name(name)
  begin
    wait do
      button_exact(name).click
    end
  rescue =>ex
    TakeTakesScreenshot()
    raise Exception,"#{id}异常!#{ex.messge}"
  end
end
  
#点击ID
def click_by_id(id)
  begin
    wait do
      find_element(:id,id).click
    end
  rescue =>ex
    TakeTakesScreenshot()
    raise Exception,"#{id}异常!#{ex.messge}"
  end
end
def click_by_xpath(xpath)
  begin
    wait do
      find_element(:xpath,xpath).click
    end
  rescue =>ex
    TakeTakesScreenshot()
    raise Exception,"#{id}异常!#{ex.messge}"
  end
end
#截图
def TakeTakesScreenshot()
  begin
    url()
   wait do
     dr = screenshot(Dir.pwd+"/result/image/"+ Time.now.strftime("%Y%m%d %H%M%S")+'.jpg')
   end
  rescue =>ex
    TakeTakesScreenshot()
    raise Exception,"#{}异常!#{ex.message}"
  end
end
#通过用户名点击
def click_by_name(name)
  begin
    wait do
      find_element(:name,name).click
    end
  rescue =>ex
    TakeTakesScreenshot()
    raise Exception,"#{name}异常!#{ex.message}"
  end
end

def send_by_textfield_value(val,content)
  begin
    wait do
      textfield(val).send_keys content
    end
  end
rescue =>ex
  TakeTakesScreenshot()
  raise Exception,"#{name}异常!#{ex.message}"
end

#通过name输入name键入文字
def send_by_name(name,content)
  begin
    wait do
      find_element(:name,name).send_keys content
    end
  end
rescue =>ex
  TakeTakesScreenshot()
  raise Exception,"#{name}异常!#{ex.message}"
end
#通过id输入id键入文字
def send_by_id(id,content)
  begin
    wait do
      find_element(:id,id).send_keys content
    end
  end
rescue =>ex
  TakeTakesScreenshot()
  raise Exception,"#{id}异常!#{ex.message}"
end
#新版本更新窗口弹出，点击稍后更新按钮
def wait_for_new(content,name)
  begin
    # wait for alert to show
    wait do
      text content
      find(name).click
    end
  rescue =>ex
    TakeTakesScreenshot()
    raise Exception,"#{name}异常！#{ex.message}"
  end
end
def long_press_click(name)
  begin
    wait do
      e = find_element(:name, name)
      Appium::TouchAction.new.long_press(element: e, x: 0.5, y: 0.5).release(element: e).perform
    end
  rescue =>ex
    raise Exception,"#{name}异常！#{ex.message}"
  end
end
#执行下滑动作
def swipe_down(num)
  begin
    width = window_size.width
    height = window_size.height 
    for i in 0..num
      wait do
        swipe :start_x => 0.5 * width, :start_y => 0.1 * height, :offset_x => 0.5 * width , :offset_y => 0.8 * height, :duration => 50
      end
    end
  end
rescue =>ex
  TakeTakesScreenshot()
  raise Exception,"#{num}异常！#{ex.message}"
end
#执行上滑动作
def swipe_up(num)
  begin
    width = window_size.width
    height = window_size.height
    for i in 0..num
      wait do
        swipe :start_x => 0.5 * width, :start_y => 0.8 * height, :offset_x => 0.5 * width , :offset_y => -0.8 * height, :duration => 50
      end
    end
  end
rescue =>ex
  TakeTakesScreenshot()
  raise Exception,"#{num}异常！#{ex.message}"
end
#执行左滑动作
def swipe_left(num)
  begin
    width = window_size.width
    height = window_size.height
    for i in 1..num
      wait do
        swipe :start_x => 0.8 * width, :start_y => 0.5 * height, :offset_x => -0.8 * width , :offset_y => 0.5 * height, :duration => 50
      end
    end
  rescue =>ex
    TakeTakesScreenshot()
    raise Exception,"#{num}异常！#{ex.message}"
  end
end
#执行右滑动作
def swipe_right(num)
  begin
    width = window_size.width
    height = window_size.height 
    for i in 0..num
      wait do
        swipe :start_x => 0.1 * width, :start_y => 0.5 * height, :offset_x => 0.8 * width , :offset_y => 0.5 * height, :duration => 50
      end
    end
  end
rescue =>ex
  TakeTakesScreenshot()
  raise Exception,"#{num}异常！#{ex.message}"
end




def scroll(direction)
  begin
    execute_script 'mobile: scroll', direction: direction
  rescue Selenium::WebDriver::Error::JavascriptError
  end
end

def scrollUp
  scroll 'up'
end

def scrollDown
  scroll 'down'
end

def scrollLeft
  scroll 'left'
end

def scrollRight
  scroll 'right'
end




def fill_in_by_textfield_value(val,opts)
  content  = opts.fetch :with, ''  
  begin
    wait do
      textfield(val).send_keys content
    end
  end
rescue =>ex
  TakeTakesScreenshot()
  raise Exception,"#{name}异常!#{ex.message}"
end


#通过name输入name键入文字
def fill_in_by_name(name,opts)
  content  = opts.fetch :with, ''  
  begin
    wait do
      find_element(:name,name).send_keys content
    end
  end
rescue =>ex
  TakeTakesScreenshot()
  raise Exception,"#{name}异常!#{ex.message}"
end


#通过id输入id键入文字
def fill_in_by_id(id,opts)
  content  = opts.fetch :with, ''  
  begin
    wait do
      find_element(:id,id).send_keys content
    end
  end
rescue =>ex
  TakeTakesScreenshot()
  raise Exception,"#{id}异常!#{ex.message}"
end



def should_have_text(text)
  wait { text_exact text }
end

def should_have_textfield(text)
  wait { textfield text }
end

def should_have_button(name)
  wait { button_exact name }
end

def should_have_class(name)
  wait { tag name }
end

def should_not_exist(control_id)
  wait { id control_id }
  raise "#{control_id} still exists!"
rescue Selenium::WebDriver::Error::TimeOutError => ex
end

def check_element(control_element)
  if control_element.start_with?('!')
    control_element = control_element[1..-1]
    should_not_exist control_element
  else
    wait { id control_element }
  end
end

def check_elements(control_ids)
  """check if control elements exist as expectation.
    - if control_ids is like !A, A should not be existed.
    - if control_ids is like A||B, either A or B exists will be OK.
    - if control_ids is like A&&B, only A and B exists will be OK.
    - if control_ids is like A&&!B, A should be existed and B should not be existed.
  """
  check_result = true
  if control_ids.include? '&&'
    control_ids.split('&&').each do |control_element|
      check_element(control_element.strip)
    end
  else
    check_result = false
    control_ids.split('||').each do |control_element|
      begin
        check_element(control_element.strip)
        check_result = true
        break
      rescue Selenium::WebDriver::Error::TimeOutError => ex
        next
      end
    end
    raise "#{control_ids} not exist" if not check_result
  end
  check_result
end  

