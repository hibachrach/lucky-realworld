abstract class ApiAction < Lucky::Action
  # Include modules and add methods that are for all API requests
  macro nested_param(type_declaration, nested_under parent_param_key)
    def {{ type_declaration.var }} : {{ type_declaration.type }}
      {% is_nilable_type = type_declaration.type.is_a?(Union) %}
      {% type = is_nilable_type ? type_declaration.type.types.first : type_declaration.type %}

      top_level_hash = params.nested?(:{{ parent_param_key.id }})

      val = top_level_hash.try(&.["{{ type_declaration.var }}"]?)

      if val.nil?
        default_or_nil = {{ type_declaration.value || nil }}
        {% if is_nilable_type %}
          return default_or_nil
        {% else %}
          return default_or_nil ||
            raise Lucky::Exceptions::MissingParam.new("{{ type_declaration.var.id }}")
        {% end %}
      end

      result = {{ type }}::Lucky.parse(val)

      if result.is_a? {{ type }}::Lucky::SuccessfulCast
        result.value
      else
        raise Lucky::Exceptions::InvalidParam.new(
          param_name: "{{ type_declaration.var.id }}",
          param_value: val.to_s,
          param_type: "{{ type }}"
        )
      end
    end
  end
end
