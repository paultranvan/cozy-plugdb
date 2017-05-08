Rule = require '../models/rule'
File = require '../models/file'
Contact = require '../models/contact'

module.exports = ACLView = Backbone.View.extend(
    el: '#acl'
    template: require('../templates/acl')

    initialize: ->
        console.log 'model : ', @model.get('id')
        @listenTo @model, 'change', @killView
        @model.on "change:aclStatus", @killView
        @render()

    render: () ->
        rule = @model.toJSON()
        domain = window.location.origin
        @$el.html @template({rule: rule, domain: domain})
        _this = @

        # Fetch files
        rule.docIDs.forEach (docid) ->

            file = new File(id: docid)
            file.fetch({
                success: () ->
                    filename = file.get('name')
                    href = domain+"/files/"+docid+"/attach/"+filename
                    $("#"+docid+" td:first a").attr('href', href)
                    $("#"+docid+" td:first a").text(filename)
                    sensitive = _this.checkTags(docid)
                    if sensitive is true
                        console.log 'TRUE DAT'
                        $("#"+docid).attr('class', 'danger')
                    else
                        $("#"+docid).attr('class', 'success')


                error: (err) ->
                    $("#"+docid+" p").text("deleted")
            })

        # Fetch contacts
        rule.userIDs.forEach (userid) ->
            contact = new Contact(id: userid)

            contact.fetch({
                success: () ->
                    href = domain+"/contacts/"+userid+"/picture.png"
                    fn = contact.get('fn')
                    $("#"+userid+" td:first p").text("#{fn}")

                    sensitive = _this.checkTags(userid)
                    if sensitive is true
                        $("#"+userid).attr('class', 'danger')
                    else
                        $("#"+userid).attr('class', 'success')
                error: (err) ->
                    $("#"+userid+" p").text("deleted")
            })


    killView: ()->
        console.log 'harakiri!!'
        #this.remove()

    checkTags: (docid) ->
        for tag in @model.tags
            if tag == docid
                console.log 'SENSITIVE TAG'
                return true

        return false

)
