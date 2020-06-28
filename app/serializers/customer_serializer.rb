class CustomerSerializer < ActiveModel::Serializer
    attributes :externalCode, :name, :email, :contact

    def externalCode
        object.external_code
    end
end
