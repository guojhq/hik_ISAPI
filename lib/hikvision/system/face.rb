module Hikvision
  class System
    def add_face(options = { cache: false })
      @isapi.post('/ISAPI/Intelligent/FDLib/FaceDataRecord?format=json', options).response.body
    end
  end
end
