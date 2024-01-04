module Hikvision
  class System
    def get_event(options = { cache: false })
      @isapi.post('/ISAPI/AccessControl/AcsEvent?format=json', options).response.body
    end

    # 保存刷脸照片
    def get_event_photo(url, file_path, options = { cache: false })
      file_content = @isapi.get_original(url, options).response.body
      File.open(file_path, 'wb') do |f|
        f.write(file_content)
      end
    end
  end
end
