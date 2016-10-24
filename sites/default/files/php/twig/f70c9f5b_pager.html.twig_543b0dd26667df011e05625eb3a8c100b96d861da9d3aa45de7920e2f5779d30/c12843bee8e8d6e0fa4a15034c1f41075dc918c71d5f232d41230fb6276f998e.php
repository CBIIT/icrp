<?php

/* themes/bootstrap/templates/system/pager.html.twig */
class __TwigTemplate_d855f01779f63ba8baa1864031d6c8d2a7413abb99bd5908ab6b37414396bf92 extends Twig_Template
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
        $tags = array("if" => 34, "for" => 60, "set" => 63);
        $filters = array("t" => 36, "default" => 44);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if', 'for', 'set'),
                array('t', 'default'),
                array()
            );
        } catch (Twig_Sandbox_SecurityError $e) {
            $e->setTemplateFile($this->getTemplateName());

            if ($e instanceof Twig_Sandbox_SecurityNotAllowedTagError && isset($tags[$e->getTagName()])) {
                $e->setTemplateLine($tags[$e->getTagName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFilterError && isset($filters[$e->getFilterName()])) {
                $e->setTemplateLine($filters[$e->getFilterName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFunctionError && isset($functions[$e->getFunctionName()])) {
                $e->setTemplateLine($functions[$e->getFunctionName()]);
            }

            throw $e;
        }

        // line 34
        if ((isset($context["items"]) ? $context["items"] : null)) {
            // line 35
            echo "  <nav class=\"pager-nav text-center\" role=\"navigation\" aria-labelledby=\"pagination-heading\">
    <h4 id=\"pagination-heading\" class=\"visually-hidden\">";
            // line 36
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Pagination")));
            echo "</h4>
    <ul class=\"pagination js-pager__items\">

      ";
            // line 40
            echo "      ";
            if ($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "first", array())) {
                // line 41
                echo "        <li class=\"pager__item pager__item--first\">
          <a href=\"";
                // line 42
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "first", array()), "href", array()), "html", null, true));
                echo "\" title=\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Go to first page")));
                echo "\" rel=\"prev\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "first", array()), "attributes", array()), "html", null, true));
                echo ">
            <span class=\"visually-hidden\">";
                // line 43
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("First page")));
                echo "</span>
            <span aria-hidden=\"true\">";
                // line 44
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (($this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "first", array(), "any", false, true), "text", array(), "any", true, true)) ? (_twig_default_filter($this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "first", array(), "any", false, true), "text", array()), t("first"))) : (t("first"))), "html", null, true));
                echo "</span>
          </a>
        </li>
      ";
            }
            // line 48
            echo "
      ";
            // line 50
            echo "      ";
            if ($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "previous", array())) {
                // line 51
                echo "        <li class=\"pager__item pager__item--previous\">
          <a href=\"";
                // line 52
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "previous", array()), "href", array()), "html", null, true));
                echo "\" title=\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Go to previous page")));
                echo "\" rel=\"prev\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "previous", array()), "attributes", array()), "html", null, true));
                echo ">
            <span class=\"visually-hidden\">";
                // line 53
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Previous page")));
                echo "</span>
            <span aria-hidden=\"true\">";
                // line 54
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (($this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "previous", array(), "any", false, true), "text", array(), "any", true, true)) ? (_twig_default_filter($this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "previous", array(), "any", false, true), "text", array()), t("previous"))) : (t("previous"))), "html", null, true));
                echo "</span>
          </a>
        </li>
      ";
            }
            // line 58
            echo "
      ";
            // line 60
            echo "      ";
            $context['_parent'] = $context;
            $context['_seq'] = twig_ensure_traversable($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "pages", array()));
            foreach ($context['_seq'] as $context["key"] => $context["item"]) {
                // line 61
                echo "        <li class=\"pager__item";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(((((isset($context["current"]) ? $context["current"] : null) == $context["key"])) ? (" is-active active") : (""))));
                echo "\">
          ";
                // line 62
                if (((isset($context["current"]) ? $context["current"] : null) == $context["key"])) {
                    // line 63
                    echo "            ";
                    $context["title"] = t("Current page");
                    // line 64
                    echo "          ";
                } else {
                    // line 65
                    echo "            ";
                    $context["title"] = t("Go to page @key", array("@key" => $context["key"]));
                    // line 66
                    echo "          ";
                }
                // line 67
                echo "          <a href=\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["item"], "href", array()), "html", null, true));
                echo "\" title=\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title"]) ? $context["title"] : null), "html", null, true));
                echo "\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["item"], "attributes", array()), "html", null, true));
                echo ">
            <span class=\"visually-hidden\">
              ";
                // line 69
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(((((isset($context["current"]) ? $context["current"] : null) == $context["key"])) ? (t("Current page")) : (t("Page")))));
                echo "
            </span>";
                // line 71
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $context["key"], "html", null, true));
                // line 72
                echo "</a>
        </li>
      ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['key'], $context['item'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 75
            echo "
      ";
            // line 77
            echo "      ";
            if ($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "next", array())) {
                // line 78
                echo "        <li class=\"pager__item pager__item--next\">
          <a href=\"";
                // line 79
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "next", array()), "href", array()), "html", null, true));
                echo "\" title=\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Go to next page")));
                echo "\" rel=\"next\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "next", array()), "attributes", array()), "html", null, true));
                echo ">
            <span class=\"visually-hidden\">";
                // line 80
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Next page")));
                echo "</span>
            <span aria-hidden=\"true\">";
                // line 81
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (($this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "next", array(), "any", false, true), "text", array(), "any", true, true)) ? (_twig_default_filter($this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "next", array(), "any", false, true), "text", array()), t("next"))) : (t("next"))), "html", null, true));
                echo "</span>
          </a>
        </li>
      ";
            }
            // line 85
            echo "
      ";
            // line 87
            echo "      ";
            if ($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "last", array())) {
                // line 88
                echo "      <li class=\"pager__item pager__item--last\">
        <a href=\"";
                // line 89
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "last", array()), "href", array()), "html", null, true));
                echo "\" title=\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Go to last page")));
                echo "\" rel=\"last\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "last", array()), "attributes", array()), "html", null, true));
                echo ">
          <span class=\"visually-hidden\">";
                // line 90
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Last page")));
                echo "</span>
          <span aria-hidden=\"true\">";
                // line 91
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (($this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "last", array(), "any", false, true), "text", array(), "any", true, true)) ? (_twig_default_filter($this->getAttribute($this->getAttribute((isset($context["items"]) ? $context["items"] : null), "last", array(), "any", false, true), "text", array()), t("last"))) : (t("last"))), "html", null, true));
                echo "</span>
        </a>
      </li>
      ";
            }
            // line 95
            echo "
    </ul>
  </nav>
";
        }
    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/system/pager.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  214 => 95,  207 => 91,  203 => 90,  195 => 89,  192 => 88,  189 => 87,  186 => 85,  179 => 81,  175 => 80,  167 => 79,  164 => 78,  161 => 77,  158 => 75,  150 => 72,  148 => 71,  144 => 69,  134 => 67,  131 => 66,  128 => 65,  125 => 64,  122 => 63,  120 => 62,  115 => 61,  110 => 60,  107 => 58,  100 => 54,  96 => 53,  88 => 52,  85 => 51,  82 => 50,  79 => 48,  72 => 44,  68 => 43,  60 => 42,  57 => 41,  54 => 40,  48 => 36,  45 => 35,  43 => 34,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation to display a pager.*/
/*  **/
/*  * Available variables:*/
/*  * - items: List of pager items.*/
/*  *   The list is keyed by the following elements:*/
/*  *   - first: Item for the first page; not present on the first page of results.*/
/*  *   - previous: Item for the previous page; not present on the first page*/
/*  *     of results.*/
/*  *   - next: Item for the next page; not present on the last page of results.*/
/*  *   - last: Item for the last page; not present on the last page of results.*/
/*  *   - pages: List of pages, keyed by page number.*/
/*  *   Sub-sub elements:*/
/*  *   items.first, items.previous, items.next, items.last, and each item inside*/
/*  *   items.pages contain the following elements:*/
/*  *   - href: URL with appropriate query parameters for the item.*/
/*  *   - attributes: A keyed list of HTML attributes for the item.*/
/*  *   - text: The visible text used for the item link, such as "‹ previous"*/
/*  *     or "next ›".*/
/*  * - current: The page number of the current page.*/
/*  * - ellipses: If there are more pages than the quantity allows, then an*/
/*  *   ellipsis before or after the listed pages may be present.*/
/*  *   - previous: Present if the currently visible list of pages does not start*/
/*  *     at the first page.*/
/*  *   - next: Present if the visible list of pages ends before the last page.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_pager()*/
/*  *//* */
/* #}*/
/* {% if items %}*/
/*   <nav class="pager-nav text-center" role="navigation" aria-labelledby="pagination-heading">*/
/*     <h4 id="pagination-heading" class="visually-hidden">{{ 'Pagination'|t }}</h4>*/
/*     <ul class="pagination js-pager__items">*/
/* */
/*       {# Print first item if we are not on the first page. #}*/
/*       {% if items.first %}*/
/*         <li class="pager__item pager__item--first">*/
/*           <a href="{{ items.first.href }}" title="{{ 'Go to first page'|t }}" rel="prev"{{ items.first.attributes }}>*/
/*             <span class="visually-hidden">{{ 'First page'|t }}</span>*/
/*             <span aria-hidden="true">{{ items.first.text|default('first'|t) }}</span>*/
/*           </a>*/
/*         </li>*/
/*       {% endif %}*/
/* */
/*       {# Print previous item if we are not on the first page. #}*/
/*       {% if items.previous %}*/
/*         <li class="pager__item pager__item--previous">*/
/*           <a href="{{ items.previous.href }}" title="{{ 'Go to previous page'|t }}" rel="prev"{{ items.previous.attributes }}>*/
/*             <span class="visually-hidden">{{ 'Previous page'|t }}</span>*/
/*             <span aria-hidden="true">{{ items.previous.text|default('previous'|t) }}</span>*/
/*           </a>*/
/*         </li>*/
/*       {% endif %}*/
/* */
/*       {# Now generate the actual pager piece. #}*/
/*       {% for key, item in items.pages %}*/
/*         <li class="pager__item{{ current == key ? ' is-active active' : '' }}">*/
/*           {% if current == key %}*/
/*             {% set title = 'Current page'|t %}*/
/*           {% else %}*/
/*             {% set title = 'Go to page @key'|t({'@key': key}) %}*/
/*           {% endif %}*/
/*           <a href="{{ item.href }}" title="{{ title }}"{{ item.attributes }}>*/
/*             <span class="visually-hidden">*/
/*               {{ current == key ? 'Current page'|t : 'Page'|t }}*/
/*             </span>*/
/*             {{- key -}}*/
/*           </a>*/
/*         </li>*/
/*       {% endfor %}*/
/* */
/*       {# Print next item if we are not on the last page. #}*/
/*       {% if items.next %}*/
/*         <li class="pager__item pager__item--next">*/
/*           <a href="{{ items.next.href }}" title="{{ 'Go to next page'|t }}" rel="next"{{ items.next.attributes }}>*/
/*             <span class="visually-hidden">{{ 'Next page'|t }}</span>*/
/*             <span aria-hidden="true">{{ items.next.text|default('next'|t) }}</span>*/
/*           </a>*/
/*         </li>*/
/*       {% endif %}*/
/* */
/*       {# Print last item if we are not on the last page. #}*/
/*       {% if items.last %}*/
/*       <li class="pager__item pager__item--last">*/
/*         <a href="{{ items.last.href }}" title="{{ 'Go to last page'|t }}" rel="last"{{ items.last.attributes }}>*/
/*           <span class="visually-hidden">{{ 'Last page'|t }}</span>*/
/*           <span aria-hidden="true">{{ items.last.text|default('last'|t) }}</span>*/
/*         </a>*/
/*       </li>*/
/*       {% endif %}*/
/* */
/*     </ul>*/
/*   </nav>*/
/* {% endif %}*/
/* */
