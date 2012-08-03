# Display or hide a jQuery DOM element, depending on a form element value
# Dependences: jQuery ; Underscore.js

# Sample:
# -------
# <select name="selector">
#   <option value="0">hide</option>
#   <optoon valie="1">show</option>
# </select>
# <div data-display-if="selector" data-has-value="[1]">lorem</div>
#
# <script type="text/javascript">
#   $('[data-display-if]').conditionallyDisplayed()
# </script>

(($) ->
  class ConditionallyDisplayed
    constructor: (@jQueryNode) ->
      # Saves the element on his initial state (replaced by empty content when hidden)
      @nodeBackup = @jQueryNode
      # The form element the display depends of
      @associatedNode = $("[name='#{@jQueryNode.data 'display-if'}']")
      # Values expected to show the element
      @expectedValues = @jQueryNode.data 'has-value'

      @bindEvents()
      @updateDisplay()

    bindEvents: ->
      @associatedNode.change (event) => @updateDisplay()

    updateDisplay: ->
      if @display() then @showNode() else @hideNode()

    # Should we display the node ? => returns true or false
    display: ->
      _.include(@expectedValues, @valueOfAssociatedNode())

    # Get the value of the form element we depend of
    valueOfAssociatedNode: ->
      if @associatedNode.attr('type') == 'radio'
        @associatedNode.filter(':checked').val()
      else
        @associatedNode.val()

    showNode: ->
      @replaceNodeBy(@nodeBackup)

    hideNode: ->
      @replaceNodeBy($())

    replaceNodeBy: (content) ->
      @jQueryNode = content.replaceAll(@jQueryNode)

  # jQuery plugin
  $.fn.conditionallyDisplayed = ->
    this.each -> new ConditionallyDisplayed $(this)
)(jQuery)
