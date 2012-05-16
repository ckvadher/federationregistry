<!DOCTYPE html>

<html>
  <head>
    <title><g:message code='fr.branding.title' default='Federation Registry'/></title>
    <r:require modules="modernizr, bootstrap, bootstrap-datepicker, validate, datatables, alphanumeric, zenbox, app"/>
    <r:layoutResources/>
    <g:layoutHead />
  </head>

  <body>
    <div class="container">
      <header>
        <div class="row">
          <div class="span12">
            <g:render template='/templates/frheader' />
          </div>
        </div>
      </header>

      <nav>
        <div class="row">
          <div class="span12">
            <ul class="level1">
              <li class="${controllerName == 'initialBootstrap' ? 'directactive':''}">
                <g:link controller="initialBootstrap"><g:message code="branding.fr.nav.bootstrap" default="Bootstrap"/></g:link>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <section>
        <g:layoutBody/>
      </section>

      <footer>
        <div class="row">
          <div class="span12">
            <g:render template='/templates/frfooter' />
          </div>
        </div>
      </footer>
    </div>

    <r:layoutResources/>
    
  </body>

</html>