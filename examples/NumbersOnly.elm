import Char (isDigit)
import Debug
import String (all,any)
import Graphics.Input (Input, input)
import Graphics.Input.Field as Field

main : Signal Element
main =
    let raw = watchContent "Raw" <~ numbers.signal
        allNumbers content = any isDigit content.string
        filtered = keepIf allNumbers Field.noContent raw
    in
        display . watchContent "Filtered" <~ filtered

numbers : Input Field.Content
numbers = input Field.noContent

display : Field.Content -> Element
display content =
    Field.field Field.defaultStyle numbers.handle id "Only numbers!" content

watchContent : String -> Field.Content -> Field.Content
watchContent tag = Debug.watchSummary tag .string

