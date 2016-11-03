<?php

/* @webprofiler/Collector/drupal.html.twig */
class __TwigTemplate_9692d49c34ffe866791e01800580428ad98cdd32ea710477891b23876e2d7cfd extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        $this->parent = false;

        $this->blocks = array(
            'toolbar' => array($this, 'block_toolbar'),
            'panel' => array($this, 'block_panel'),
        );
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $__internal_a49bfe700fa6dd3356d1044dbd9995387e923d1295292aae68e16ee4270af4fd = $this->env->getExtension("native_profiler");
        $__internal_a49bfe700fa6dd3356d1044dbd9995387e923d1295292aae68e16ee4270af4fd->enter($__internal_a49bfe700fa6dd3356d1044dbd9995387e923d1295292aae68e16ee4270af4fd_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "@webprofiler/Collector/drupal.html.twig"));

        $tags = array("block" => 1, "set" => 2, "spaceless" => 12, "if" => 22);
        $filters = array("t" => 14, "default" => 53);
        $functions = array("url" => 34);

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('block', 'set', 'spaceless', 'if'),
                array('t', 'default'),
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
        $this->displayBlock('toolbar', $context, $blocks);
        // line 57
        echo "
";
        // line 58
        $this->displayBlock('panel', $context, $blocks);
        // line 66
        echo "
";
        
        $__internal_a49bfe700fa6dd3356d1044dbd9995387e923d1295292aae68e16ee4270af4fd->leave($__internal_a49bfe700fa6dd3356d1044dbd9995387e923d1295292aae68e16ee4270af4fd_prof);

    }

    // line 1
    public function block_toolbar($context, array $blocks = array())
    {
        $__internal_16c5f9481aa0bdf4e5e74259a0f65d735e4508d9940f5fcc91ac5c7bb2089889 = $this->env->getExtension("native_profiler");
        $__internal_16c5f9481aa0bdf4e5e74259a0f65d735e4508d9940f5fcc91ac5c7bb2089889->enter($__internal_16c5f9481aa0bdf4e5e74259a0f65d735e4508d9940f5fcc91ac5c7bb2089889_prof = new Twig_Profiler_Profile($this->getTemplateName(), "block", "toolbar"));

        // line 2
        echo "    ";
        ob_start();
        // line 3
        echo "    <span>
        <img width=\"13\" height=\"28\" alt=\"Drupal\"
             src=\"data:image/png;base64,";
        // line 5
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["collector"]) ? $context["collector"] : null), "icon", array()), "html", null, true));
        echo "\">
        <a href=\"https://www.drupal.org\">
            <span>";
        // line 7
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["collector"]) ? $context["collector"] : null), "version", array()), "html", null, true));
        echo "</span>
        </a>
        </span>
    ";
        $context["icon"] = ('' === $tmp = ob_get_clean()) ? '' : new Twig_Markup($tmp, $this->env->getCharset());
        // line 11
        echo "    ";
        ob_start();
        // line 12
        echo "    ";
        ob_start();
        // line 13
        echo "        <div class=\"sf-toolbar-info-piece\">
            <b>";
        // line 14
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Drupal version")));
        echo "</b>
            <span>";
        // line 15
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["collector"]) ? $context["collector"] : null), "version", array()), "html", null, true));
        echo "</span>
        </div>
        <div class=\"sf-toolbar-info-piece\">
            <b>";
        // line 18
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Installed profile")));
        echo "</b>
            <span>";
        // line 19
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["collector"]) ? $context["collector"] : null), "profile", array()), "html", null, true));
        echo "</span>
        </div>

        ";
        // line 22
        if ($this->getAttribute((isset($context["collector"]) ? $context["collector"] : null), "getGitCommit", array())) {
            // line 23
            echo "        <div class=\"sf-toolbar-info-piece\">
            <b>";
            // line 24
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Git commit")));
            echo "</b>
            <span><abbr title=\"";
            // line 25
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["collector"]) ? $context["collector"] : null), "getGitCommit", array()), "html", null, true));
            echo "\">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["collector"]) ? $context["collector"] : null), "getAbbrGitCommit", array()), "html", null, true));
            echo "</abbr></span>
        </div>
        ";
        }
        // line 28
        echo "
        <div class=\"sf-toolbar-info-piece\">
            <span><a href=\"";
        // line 30
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["collector"]) ? $context["collector"] : null), "getConfigUrl", array()), "html", null, true));
        echo "\"
                     title=\"";
        // line 31
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Configure Webprofiler")));
        echo "\">";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Configure Webprofiler")));
        echo "</a></span>
        </div>
        <div class=\"sf-toolbar-info-piece\">
            <span><a href=\"";
        // line 34
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar($this->env->getExtension('drupal_core')->getUrl("webprofiler.admin_list")));
        echo "\"
                     title=\"";
        // line 35
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("View latest reports")));
        echo "\">";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("View latest reports")));
        echo "</a></span>
        </div>
        <hr/>
        <div class=\"sf-toolbar-info-piece\">
            <span><a href=\"https://www.drupal.org/documentation\">";
        // line 39
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Drupal Documentation")));
        echo "</a></span>
        </div>
        <div class=\"sf-toolbar-info-piece\">
            <span><a href=\"https://www.drupal.org/contribute\">";
        // line 42
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Get involved!")));
        echo "</a></span>
        </div>
    ";
        echo trim(preg_replace('/>\s+</', '><', ob_get_clean()));
        // line 45
        echo "    ";
        $context["text"] = ('' === $tmp = ob_get_clean()) ? '' : new Twig_Markup($tmp, $this->env->getCharset());
        // line 46
        echo "
    ";
        // line 47
        if ((isset($context["link"]) ? $context["link"] : null)) {
            // line 48
            echo "        ";
            ob_start();
            // line 49
            echo "        <a href=\"#\">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["icon"]) ? $context["icon"] : null), "html", null, true));
            echo "</a>
        ";
            $context["icon"] = ('' === $tmp = ob_get_clean()) ? '' : new Twig_Markup($tmp, $this->env->getCharset());
            // line 51
            echo "    ";
        }
        // line 52
        echo "    <div class=\"sf-toolbar-block\">
        <div class=\"sf-toolbar-icon\">";
        // line 53
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, ((array_key_exists("icon", $context)) ? (_twig_default_filter((isset($context["icon"]) ? $context["icon"] : null), "")) : ("")), "html", null, true));
        echo "</div>
        <div class=\"sf-toolbar-info\">";
        // line 54
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, ((array_key_exists("text", $context)) ? (_twig_default_filter((isset($context["text"]) ? $context["text"] : null), "")) : ("")), "html", null, true));
        echo "</div>
    </div>
";
        
        $__internal_16c5f9481aa0bdf4e5e74259a0f65d735e4508d9940f5fcc91ac5c7bb2089889->leave($__internal_16c5f9481aa0bdf4e5e74259a0f65d735e4508d9940f5fcc91ac5c7bb2089889_prof);

    }

    // line 58
    public function block_panel($context, array $blocks = array())
    {
        $__internal_b2e7176807988d0a883198c072f24d66a557a9790dcef0865bbc87b0de5639ec = $this->env->getExtension("native_profiler");
        $__internal_b2e7176807988d0a883198c072f24d66a557a9790dcef0865bbc87b0de5639ec->enter($__internal_b2e7176807988d0a883198c072f24d66a557a9790dcef0865bbc87b0de5639ec_prof = new Twig_Profiler_Profile($this->getTemplateName(), "block", "panel"));

        // line 59
        echo "    <script id=\"drupal\" type=\"text/template\">
        <h2 class=\"panel__title\">";
        // line 60
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Drupal")));
        echo "</h2>
        <div class=\"panel__container\">

        </div>
    </script>
";
        
        $__internal_b2e7176807988d0a883198c072f24d66a557a9790dcef0865bbc87b0de5639ec->leave($__internal_b2e7176807988d0a883198c072f24d66a557a9790dcef0865bbc87b0de5639ec_prof);

    }

    public function getTemplateName()
    {
        return "@webprofiler/Collector/drupal.html.twig";
    }

    public function getDebugInfo()
    {
        return array (  221 => 60,  218 => 59,  212 => 58,  202 => 54,  198 => 53,  195 => 52,  192 => 51,  186 => 49,  183 => 48,  181 => 47,  178 => 46,  175 => 45,  169 => 42,  163 => 39,  154 => 35,  150 => 34,  142 => 31,  138 => 30,  134 => 28,  126 => 25,  122 => 24,  119 => 23,  117 => 22,  111 => 19,  107 => 18,  101 => 15,  97 => 14,  94 => 13,  91 => 12,  88 => 11,  81 => 7,  76 => 5,  72 => 3,  69 => 2,  63 => 1,  55 => 66,  53 => 58,  50 => 57,  48 => 1,);
    }
}
/* {% block toolbar %}*/
/*     {% set icon %}*/
/*     <span>*/
/*         <img width="13" height="28" alt="Drupal"*/
/*              src="data:image/png;base64,{{ collector.icon }}">*/
/*         <a href="https://www.drupal.org">*/
/*             <span>{{ collector.version }}</span>*/
/*         </a>*/
/*         </span>*/
/*     {% endset %}*/
/*     {% set text %}*/
/*     {% spaceless %}*/
/*         <div class="sf-toolbar-info-piece">*/
/*             <b>{{ 'Drupal version'|t }}</b>*/
/*             <span>{{ collector.version }}</span>*/
/*         </div>*/
/*         <div class="sf-toolbar-info-piece">*/
/*             <b>{{ 'Installed profile'|t }}</b>*/
/*             <span>{{ collector.profile }}</span>*/
/*         </div>*/
/* */
/*         {% if collector.getGitCommit %}*/
/*         <div class="sf-toolbar-info-piece">*/
/*             <b>{{ 'Git commit'|t }}</b>*/
/*             <span><abbr title="{{ collector.getGitCommit }}">{{ collector.getAbbrGitCommit }}</abbr></span>*/
/*         </div>*/
/*         {% endif %}*/
/* */
/*         <div class="sf-toolbar-info-piece">*/
/*             <span><a href="{{ collector.getConfigUrl }}"*/
/*                      title="{{ 'Configure Webprofiler'|t }}">{{ 'Configure Webprofiler'|t }}</a></span>*/
/*         </div>*/
/*         <div class="sf-toolbar-info-piece">*/
/*             <span><a href="{{ url("webprofiler.admin_list") }}"*/
/*                      title="{{ 'View latest reports'|t }}">{{ 'View latest reports'|t }}</a></span>*/
/*         </div>*/
/*         <hr/>*/
/*         <div class="sf-toolbar-info-piece">*/
/*             <span><a href="https://www.drupal.org/documentation">{{ 'Drupal Documentation'|t }}</a></span>*/
/*         </div>*/
/*         <div class="sf-toolbar-info-piece">*/
/*             <span><a href="https://www.drupal.org/contribute">{{ 'Get involved!'|t }}</a></span>*/
/*         </div>*/
/*     {% endspaceless %}*/
/*     {% endset %}*/
/* */
/*     {% if link %}*/
/*         {% set icon %}*/
/*         <a href="#">{{ icon }}</a>*/
/*         {% endset %}*/
/*     {% endif %}*/
/*     <div class="sf-toolbar-block">*/
/*         <div class="sf-toolbar-icon">{{ icon|default('') }}</div>*/
/*         <div class="sf-toolbar-info">{{ text|default('') }}</div>*/
/*     </div>*/
/* {% endblock %}*/
/* */
/* {% block panel %}*/
/*     <script id="drupal" type="text/template">*/
/*         <h2 class="panel__title">{{ 'Drupal'|t }}</h2>*/
/*         <div class="panel__container">*/
/* */
/*         </div>*/
/*     </script>*/
/* {% endblock %}*/
/* */
/* */
