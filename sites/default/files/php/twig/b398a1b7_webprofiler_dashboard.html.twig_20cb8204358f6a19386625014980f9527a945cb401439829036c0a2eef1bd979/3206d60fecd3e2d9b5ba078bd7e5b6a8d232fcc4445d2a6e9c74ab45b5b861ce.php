<?php

/* modules/devel/webprofiler/templates/Profiler/webprofiler_dashboard.html.twig */
class __TwigTemplate_7ef1b1a42e09e98bc7a9b6bebb0cd670130c868e1fe8d5cb671b931fcfc276ec extends Twig_Template
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
        $__internal_afe3bb656318262c0bdab98a85e285e4759a56e53f20e13a98cd587234082b24 = $this->env->getExtension("native_profiler");
        $__internal_afe3bb656318262c0bdab98a85e285e4759a56e53f20e13a98cd587234082b24->enter($__internal_afe3bb656318262c0bdab98a85e285e4759a56e53f20e13a98cd587234082b24_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/devel/webprofiler/templates/Profiler/webprofiler_dashboard.html.twig"));

        $tags = array("set" => 1, "if" => 5);
        $filters = array("upper" => 4, "date" => 12, "t" => 16);
        $functions = array("url" => 16);

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set', 'if'),
                array('upper', 'date', 't'),
                array('url')
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

        // line 1
        ob_start();
        // line 2
        echo "<div id=\"resume\" class=\"resume\">
    <span class=\"resume__subtitle\">
        ";
        // line 4
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, twig_upper_filter($this->env, $this->getAttribute((isset($context["profile"]) ? $context["profile"] : null), "method", array())), "html", null, true));
        echo "
        ";
        // line 5
        if (twig_in_filter(twig_upper_filter($this->env, $this->getAttribute((isset($context["profile"]) ? $context["profile"] : null), "method", array())), array(0 => "GET", 1 => "HEAD"))) {
            // line 6
            echo "            <a href=\"";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["profile"]) ? $context["profile"] : null), "url", array()), "html", null, true));
            echo "\">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["profile"]) ? $context["profile"] : null), "url", array()), "html", null, true));
            echo "</a>
        ";
        } else {
            // line 8
            echo "            <em>";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["profile"]) ? $context["profile"] : null), "url", array()), "html", null, true));
            echo "</em>
        ";
        }
        // line 10
        echo "    </span>
    <span class=\"resume__time\">
        <em>by ";
        // line 12
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["profile"]) ? $context["profile"] : null), "ip", array()), "html", null, true));
        echo "</em> at <em>";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, twig_date_format_filter($this->env, $this->getAttribute((isset($context["profile"]) ? $context["profile"] : null), "time", array()), "r"), "html", null, true));
        echo "</em>
    </span>

    <a id=\"resume-view-all\" class=\"button--flat resume__button\"
       href=\"";
        // line 16
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar($this->env->getExtension('drupal_core')->getUrl("webprofiler.admin_list")));
        echo "\">";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("View latest")));
        echo "</a>
</div>
";
        $context["resume"] = ('' === $tmp = ob_get_clean()) ? '' : new Twig_Markup($tmp, $this->env->getCharset());
        // line 19
        echo "
<div id=\"webprofiler\">

    ";
        // line 22
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["resume"]) ? $context["resume"] : null), "html", null, true));
        echo "

    <div id=\"collectors\" class=\"collectors panel\">
    </div>

    <div class=\"loader--fixed\" style=\"display: none\">
        <svg class=\"loader__circle\">
            <circle class=\"loader__path\" cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke-width=\"2\" stroke-miterlimit=\"10\"/>
        </svg>
    </div>

    <script id=\"collector\" type=\"text/template\">
        <a href=\"#<%= id %>\" title=\"<%= summary %>\" class=\"overview__link\">
            <img src=\"data:image/png;base64,<%= icon %>\"
                 class=\"overview__icon\">
            <span class=\"overview__title\"><%= label %></span>
            <% if(typeof(summary) !== \"undefined\") { %>
            <span class=\"overview__subtitle\"><%= summary %></span>
            <% } %>
        </a>
    </script>

    ";
        // line 44
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["panels"]) ? $context["panels"] : null), "html", null, true));
        echo "

    <div class=\"modal js--modal\" style=\"display: none\">
        <div class=\"modal__container\">
            <div class=\"modal__bar\">
                <h3 class=\"modal__title\"></h3>
            </div>
            <div class=\"modal__content\">
                <div class=\"modal__main-data\"></div>
            </div>
            <a class=\"button--flat js--modal-close l-right\">Close</a>
        </div>
    </div>
</div>
";
        
        $__internal_afe3bb656318262c0bdab98a85e285e4759a56e53f20e13a98cd587234082b24->leave($__internal_afe3bb656318262c0bdab98a85e285e4759a56e53f20e13a98cd587234082b24_prof);

    }

    public function getTemplateName()
    {
        return "modules/devel/webprofiler/templates/Profiler/webprofiler_dashboard.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  123 => 44,  98 => 22,  93 => 19,  85 => 16,  76 => 12,  72 => 10,  66 => 8,  58 => 6,  56 => 5,  52 => 4,  48 => 2,  46 => 1,);
    }
}
/* {% set resume %}*/
/* <div id="resume" class="resume">*/
/*     <span class="resume__subtitle">*/
/*         {{ profile.method|upper }}*/
/*         {% if profile.method|upper in ['GET', 'HEAD'] %}*/
/*             <a href="{{ profile.url }}">{{ profile.url }}</a>*/
/*         {% else %}*/
/*             <em>{{ profile.url }}</em>*/
/*         {% endif %}*/
/*     </span>*/
/*     <span class="resume__time">*/
/*         <em>by {{ profile.ip }}</em> at <em>{{ profile.time|date('r') }}</em>*/
/*     </span>*/
/* */
/*     <a id="resume-view-all" class="button--flat resume__button"*/
/*        href="{{ url("webprofiler.admin_list") }}">{{ 'View latest'|t }}</a>*/
/* </div>*/
/* {% endset %}*/
/* */
/* <div id="webprofiler">*/
/* */
/*     {{ resume }}*/
/* */
/*     <div id="collectors" class="collectors panel">*/
/*     </div>*/
/* */
/*     <div class="loader--fixed" style="display: none">*/
/*         <svg class="loader__circle">*/
/*             <circle class="loader__path" cx="50" cy="50" r="20" fill="none" stroke-width="2" stroke-miterlimit="10"/>*/
/*         </svg>*/
/*     </div>*/
/* */
/*     <script id="collector" type="text/template">*/
/*         <a href="#<%= id %>" title="<%= summary %>" class="overview__link">*/
/*             <img src="data:image/png;base64,<%= icon %>"*/
/*                  class="overview__icon">*/
/*             <span class="overview__title"><%= label %></span>*/
/*             <% if(typeof(summary) !== "undefined") { %>*/
/*             <span class="overview__subtitle"><%= summary %></span>*/
/*             <% } %>*/
/*         </a>*/
/*     </script>*/
/* */
/*     {{ panels }}*/
/* */
/*     <div class="modal js--modal" style="display: none">*/
/*         <div class="modal__container">*/
/*             <div class="modal__bar">*/
/*                 <h3 class="modal__title"></h3>*/
/*             </div>*/
/*             <div class="modal__content">*/
/*                 <div class="modal__main-data"></div>*/
/*             </div>*/
/*             <a class="button--flat js--modal-close l-right">Close</a>*/
/*         </div>*/
/*     </div>*/
/* </div>*/
/* */
