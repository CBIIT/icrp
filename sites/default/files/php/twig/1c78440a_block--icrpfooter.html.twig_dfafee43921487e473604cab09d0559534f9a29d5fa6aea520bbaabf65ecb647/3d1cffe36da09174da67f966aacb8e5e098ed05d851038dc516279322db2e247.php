<?php

/* themes/bootstrap_subtheme/templates/blocks/block--icrpfooter.html.twig */
class __TwigTemplate_ed3163c085922d3f33b1ffee444a8f2750132640353a2857bf2e5c834543506f extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        $this->parent = false;

        $this->blocks = array(
        );
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $tags = array();
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('Twig_Extension_Sandbox')->checkSecurity(
                array(),
                array(),
                array()
            );
        } catch (Twig_Sandbox_SecurityError $e) {
            $e->setSourceContext($this->getSourceContext());

            if ($e instanceof Twig_Sandbox_SecurityNotAllowedTagError && isset($tags[$e->getTagName()])) {
                $e->setTemplateLine($tags[$e->getTagName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFilterError && isset($filters[$e->getFilterName()])) {
                $e->setTemplateLine($filters[$e->getFilterName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFunctionError && isset($functions[$e->getFunctionName()])) {
                $e->setTemplateLine($functions[$e->getFunctionName()]);
            }

            throw $e;
        }

        // line 1
        echo "<div class=\"container\" style=\"width:100%;\">
    <div class=\"row\">
        <div class=\"col-sm-12\">
            <nav class=\"contextual-region\" id=\"block-footermiddle\" aria-labelledby=\"block-footermiddle-menu\" role=\"navigation\">

                <h2 id=\"block-footermiddle-menu\" class=\"visually-hidden\">Footer Middle</h2>
                <div data-contextual-id=\"block:block=footermiddle:langcode=en|menu:menu=footer-middle:langcode=en\" class=\"contextual\" role=\"form\"><button type=\"button\" class=\"trigger focusable visually-hidden\" aria-pressed=\"false\">Open Footer Middle configuration options</button>
                    <ul hidden=\"\" class=\"contextual-links\"><li class=\"block-configure\"><a href=\"/admin/structure/block/manage/footermiddle?destination=node/12\">Configure block</a></li><li class=\"entitymenuedit-form\"><a href=\"/admin/structure/menu/manage/footer-middle?destination=node/12\">Edit menu</a></li></ul>

                </div>
                <div class=\"text-center\">
                <ul class=\"menu nav\">
                    <li class=\"expanded dropdown\">
                        <a data-drupal-link-system-path=\"yamlform/contact\" title=\"Contact Us\" href=\"/contact-us\">Contact Us</a>
                    </li>
                </ul>
                </div>
            </nav>
        </div>
    </div>
</div>
";
    }

    public function getTemplateName()
    {
        return "themes/bootstrap_subtheme/templates/blocks/block--icrpfooter.html.twig";
    }

    public function getDebugInfo()
    {
        return array (  43 => 1,);
    }

    /** @deprecated since 1.27 (to be removed in 2.0). Use getSourceContext() instead */
    public function getSource()
    {
        @trigger_error('The '.__METHOD__.' method is deprecated since version 1.27 and will be removed in 2.0. Use getSourceContext() instead.', E_USER_DEPRECATED);

        return $this->getSourceContext()->getCode();
    }

    public function getSourceContext()
    {
        return new Twig_Source("<div class=\"container\" style=\"width:100%;\">
    <div class=\"row\">
        <div class=\"col-sm-12\">
            <nav class=\"contextual-region\" id=\"block-footermiddle\" aria-labelledby=\"block-footermiddle-menu\" role=\"navigation\">

                <h2 id=\"block-footermiddle-menu\" class=\"visually-hidden\">Footer Middle</h2>
                <div data-contextual-id=\"block:block=footermiddle:langcode=en|menu:menu=footer-middle:langcode=en\" class=\"contextual\" role=\"form\"><button type=\"button\" class=\"trigger focusable visually-hidden\" aria-pressed=\"false\">Open Footer Middle configuration options</button>
                    <ul hidden=\"\" class=\"contextual-links\"><li class=\"block-configure\"><a href=\"/admin/structure/block/manage/footermiddle?destination=node/12\">Configure block</a></li><li class=\"entitymenuedit-form\"><a href=\"/admin/structure/menu/manage/footer-middle?destination=node/12\">Edit menu</a></li></ul>

                </div>
                <div class=\"text-center\">
                <ul class=\"menu nav\">
                    <li class=\"expanded dropdown\">
                        <a data-drupal-link-system-path=\"yamlform/contact\" title=\"Contact Us\" href=\"/contact-us\">Contact Us</a>
                    </li>
                </ul>
                </div>
            </nav>
        </div>
    </div>
</div>
", "themes/bootstrap_subtheme/templates/blocks/block--icrpfooter.html.twig", "/github/drupal8.dev/sites/icrp/themes/bootstrap_subtheme/templates/blocks/block--icrpfooter.html.twig");
    }
}
