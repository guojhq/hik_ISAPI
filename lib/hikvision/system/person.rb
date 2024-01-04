module Hikvision
  class System
    def add_person(options = { cache: false })
      @isapi.post('/ISAPI/AccessControl/UserInfo/Record?format=json', options).response.body
    end

    def delete_person(options = { cache: false })
      @isapi.put('/ISAPI/AccessControl/UserInfo/Delete?format=json', options).response.body
    end
  end
end
