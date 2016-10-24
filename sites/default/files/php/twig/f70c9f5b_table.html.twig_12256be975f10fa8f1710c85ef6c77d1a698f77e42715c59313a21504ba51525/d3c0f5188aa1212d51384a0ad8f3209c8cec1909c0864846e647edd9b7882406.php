<?php

/* themes/bootstrap/templates/system/table.html.twig */
class __TwigTemplate_3d9fe5092f16957fe920b8b151523e0c41c158c36928cdc3e7f8619a19f210b3 extends Twig_Template
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
        $tags = array("if" => 45, "set" => 48, "for" => 60);
        $filters = array();
        $functions = array("cycle" => 94);

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if', 'set', 'for'),
                array(),
                array('cycle')
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

        // line 45
        if ((isset($context["responsive"]) ? $context["responsive"] : null)) {
            // line 46
            echo "  <div class=\"table-responsive\">
";
        }
        // line 48
        $context["classes"] = array(0 => "table", 1 => ((( !twig_test_empty($this->getAttribute(        // line 50
(isset($context["context"]) ? $context["context"] : null), "bordered", array())) || $this->getAttribute($this->getAttribute((isset($context["theme"]) ? $context["theme"] : null), "settings", array()), "table_bordered", array()))) ? ("table-bordered") : ("")), 2 => ((( !twig_test_empty($this->getAttribute(        // line 51
(isset($context["context"]) ? $context["context"] : null), "condensed", array())) || $this->getAttribute($this->getAttribute((isset($context["theme"]) ? $context["theme"] : null), "settings", array()), "table_condensed", array()))) ? ("table-condensed") : ("")), 3 => ((( !twig_test_empty($this->getAttribute(        // line 52
(isset($context["context"]) ? $context["context"] : null), "hover", array())) || $this->getAttribute($this->getAttribute((isset($context["theme"]) ? $context["theme"] : null), "settings", array()), "table_hover", array()))) ? ("table-hover") : ("")), 4 => ((( !twig_test_empty($this->getAttribute(        // line 53
(isset($context["context"]) ? $context["context"] : null), "striped", array())) || $this->getAttribute($this->getAttribute((isset($context["theme"]) ? $context["theme"] : null), "settings", array()), "table_striped", array()))) ? ("table-striped") : ("")));
        // line 55
        echo "<table";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
        echo ">
  ";
        // line 56
        if ((isset($context["caption"]) ? $context["caption"] : null)) {
            // line 57
            echo "    <caption>";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["caption"]) ? $context["caption"] : null), "html", null, true));
            echo "</caption>
  ";
        }
        // line 59
        echo "
  ";
        // line 60
        $context['_parent'] = $context;
        $context['_seq'] = twig_ensure_traversable((isset($context["colgroups"]) ? $context["colgroups"] : null));
        foreach ($context['_seq'] as $context["_key"] => $context["colgroup"]) {
            // line 61
            echo "    ";
            if ($this->getAttribute($context["colgroup"], "cols", array())) {
                // line 62
                echo "      <colgroup";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["colgroup"], "attributes", array()), "html", null, true));
                echo ">
        ";
                // line 63
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable($this->getAttribute($context["colgroup"], "cols", array()));
                foreach ($context['_seq'] as $context["_key"] => $context["col"]) {
                    // line 64
                    echo "          <col";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["col"], "attributes", array()), "html", null, true));
                    echo " />
        ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['col'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 66
                echo "      </colgroup>
    ";
            } else {
                // line 68
                echo "      <colgroup";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["colgroup"], "attributes", array()), "html", null, true));
                echo " />
    ";
            }
            // line 70
            echo "  ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['colgroup'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 71
        echo "
  ";
        // line 72
        if ((isset($context["header"]) ? $context["header"] : null)) {
            // line 73
            echo "    <thead>
      <tr>
        ";
            // line 75
            $context['_parent'] = $context;
            $context['_seq'] = twig_ensure_traversable((isset($context["header"]) ? $context["header"] : null));
            foreach ($context['_seq'] as $context["_key"] => $context["cell"]) {
                // line 76
                echo "        ";
                // line 77
                $context["cell_classes"] = array(0 => (($this->getAttribute(                // line 78
$context["cell"], "active_table_sort", array())) ? ("active") : ("")));
                // line 81
                echo "        <";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "tag", array()), "html", null, true));
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["cell"], "attributes", array()), "addClass", array(0 => (isset($context["cell_classes"]) ? $context["cell_classes"] : null)), "method"), "html", null, true));
                echo ">";
                // line 82
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "content", array()), "html", null, true));
                // line 83
                echo "</";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "tag", array()), "html", null, true));
                echo ">
      ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['cell'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 85
            echo "      </tr>
    </thead>
  ";
        }
        // line 88
        echo "
  ";
        // line 89
        if ((isset($context["rows"]) ? $context["rows"] : null)) {
            // line 90
            echo "    <tbody>
      ";
            // line 91
            $context['_parent'] = $context;
            $context['_seq'] = twig_ensure_traversable((isset($context["rows"]) ? $context["rows"] : null));
            $context['loop'] = array(
              'parent' => $context['_parent'],
              'index0' => 0,
              'index'  => 1,
              'first'  => true,
            );
            if (is_array($context['_seq']) || (is_object($context['_seq']) && $context['_seq'] instanceof Countable)) {
                $length = count($context['_seq']);
                $context['loop']['revindex0'] = $length - 1;
                $context['loop']['revindex'] = $length;
                $context['loop']['length'] = $length;
                $context['loop']['last'] = 1 === $length;
            }
            foreach ($context['_seq'] as $context["_key"] => $context["row"]) {
                // line 92
                echo "        ";
                // line 93
                $context["row_classes"] = array(0 => (( !                // line 94
(isset($context["no_striping"]) ? $context["no_striping"] : null)) ? (twig_cycle(array(0 => "odd", 1 => "even"), $this->getAttribute($context["loop"], "index0", array()))) : ("")));
                // line 97
                echo "        <tr";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["row"], "attributes", array()), "addClass", array(0 => (isset($context["row_classes"]) ? $context["row_classes"] : null)), "method"), "html", null, true));
                echo ">
          ";
                // line 98
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable($this->getAttribute($context["row"], "cells", array()));
                foreach ($context['_seq'] as $context["_key"] => $context["cell"]) {
                    // line 99
                    echo "            <";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "tag", array()), "html", null, true));
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "attributes", array()), "html", null, true));
                    echo ">";
                    // line 100
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "content", array()), "html", null, true));
                    // line 101
                    echo "</";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "tag", array()), "html", null, true));
                    echo ">
          ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['cell'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 103
                echo "        </tr>
      ";
                ++$context['loop']['index0'];
                ++$context['loop']['index'];
                $context['loop']['first'] = false;
                if (isset($context['loop']['length'])) {
                    --$context['loop']['revindex0'];
                    --$context['loop']['revindex'];
                    $context['loop']['last'] = 0 === $context['loop']['revindex0'];
                }
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['row'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 105
            echo "    </tbody>
  ";
        } elseif (        // line 106
(isset($context["empty"]) ? $context["empty"] : null)) {
            // line 107
            echo "    <tbody>
      <tr class=\"odd\">
        <td colspan=\"";
            // line 109
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["header_columns"]) ? $context["header_columns"] : null), "html", null, true));
            echo "\" class=\"empty message\">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["empty"]) ? $context["empty"] : null), "html", null, true));
            echo "</td>
      </tr>
    </tbody>
  ";
        }
        // line 113
        echo "  ";
        if ((isset($context["footer"]) ? $context["footer"] : null)) {
            // line 114
            echo "    <tfoot>
      ";
            // line 115
            $context['_parent'] = $context;
            $context['_seq'] = twig_ensure_traversable((isset($context["footer"]) ? $context["footer"] : null));
            foreach ($context['_seq'] as $context["_key"] => $context["row"]) {
                // line 116
                echo "        <tr";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["row"], "attributes", array()), "html", null, true));
                echo ">
          ";
                // line 117
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable($this->getAttribute($context["row"], "cells", array()));
                foreach ($context['_seq'] as $context["_key"] => $context["cell"]) {
                    // line 118
                    echo "            <";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "tag", array()), "html", null, true));
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "attributes", array()), "html", null, true));
                    echo ">";
                    // line 119
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "content", array()), "html", null, true));
                    // line 120
                    echo "</";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["cell"], "tag", array()), "html", null, true));
                    echo ">
          ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['cell'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 122
                echo "        </tr>
      ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['row'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 124
            echo "    </tfoot>
  ";
        }
        // line 126
        echo "</table>
";
        // line 127
        if ((isset($context["responsive"]) ? $context["responsive"] : null)) {
            // line 128
            echo "  </div>
";
        }
    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/system/table.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  290 => 128,  288 => 127,  285 => 126,  281 => 124,  274 => 122,  265 => 120,  263 => 119,  258 => 118,  254 => 117,  249 => 116,  245 => 115,  242 => 114,  239 => 113,  230 => 109,  226 => 107,  224 => 106,  221 => 105,  206 => 103,  197 => 101,  195 => 100,  190 => 99,  186 => 98,  181 => 97,  179 => 94,  178 => 93,  176 => 92,  159 => 91,  156 => 90,  154 => 89,  151 => 88,  146 => 85,  137 => 83,  135 => 82,  130 => 81,  128 => 78,  127 => 77,  125 => 76,  121 => 75,  117 => 73,  115 => 72,  112 => 71,  106 => 70,  100 => 68,  96 => 66,  87 => 64,  83 => 63,  78 => 62,  75 => 61,  71 => 60,  68 => 59,  62 => 57,  60 => 56,  55 => 55,  53 => 53,  52 => 52,  51 => 51,  50 => 50,  49 => 48,  45 => 46,  43 => 45,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation to display a table.*/
/*  **/
/*  * Available variables:*/
/*  * - attributes: HTML attributes to apply to the <table> tag.*/
/*  * - caption: A localized string for the <caption> tag.*/
/*  * - colgroups: Column groups. Each group contains the following properties:*/
/*  *   - attributes: HTML attributes to apply to the <col> tag.*/
/*  *     Note: Drupal currently supports only one table header row, see*/
/*  *     http://drupal.org/node/893530 and*/
/*  *     http://api.drupal.org/api/drupal/includes!theme.inc/function/theme_table/7#comment-5109.*/
/*  * - header: Table header cells. Each cell contains the following properties:*/
/*  *   - tag: The HTML tag name to use; either TH or TD.*/
/*  *   - attributes: HTML attributes to apply to the tag.*/
/*  *   - content: A localized string for the title of the column.*/
/*  *   - field: Field name (required for column sorting).*/
/*  *   - sort: Default sort order for this column ("asc" or "desc").*/
/*  * - sticky: A flag indicating whether to use a "sticky" table header.*/
/*  * - rows: Table rows. Each row contains the following properties:*/
/*  *   - attributes: HTML attributes to apply to the <tr> tag.*/
/*  *   - data: Table cells.*/
/*  *   - no_striping: A flag indicating that the row should receive no*/
/*  *     'even / odd' styling. Defaults to FALSE.*/
/*  *   - cells: Table cells of the row. Each cell contains the following keys:*/
/*  *     - tag: The HTML tag name to use; either TH or TD.*/
/*  *     - attributes: Any HTML attributes, such as "colspan", to apply to the*/
/*  *       table cell.*/
/*  *     - content: The string to display in the table cell.*/
/*  *     - active_table_sort: A boolean indicating whether the cell is the active*/
/*  *       table sort.*/
/*  * - footer: Table footer rows, in the same format as the rows variable.*/
/*  * - empty: The message to display in an extra row if table does not have*/
/*  *   any rows.*/
/*  * - no_striping: A boolean indicating that the row should receive no striping.*/
/*  * - header_columns: The number of columns in the header.*/
/*  * - responsive: Whether or not to use the .table-responsive wrapper.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_table()*/
/*  *//* */
/* #}*/
/* {% if responsive %}*/
/*   <div class="table-responsive">*/
/* {% endif %}*/
/* {% set classes = [*/
/*   'table',*/
/*   context.bordered is not empty or theme.settings.table_bordered ? 'table-bordered',*/
/*   context.condensed is not empty or theme.settings.table_condensed ? 'table-condensed',*/
/*   context.hover is not empty or theme.settings.table_hover ? 'table-hover',*/
/*   context.striped is not empty or theme.settings.table_striped ? 'table-striped',*/
/* ] %}*/
/* <table{{ attributes.addClass(classes) }}>*/
/*   {% if caption %}*/
/*     <caption>{{ caption }}</caption>*/
/*   {% endif %}*/
/* */
/*   {% for colgroup in colgroups %}*/
/*     {% if colgroup.cols %}*/
/*       <colgroup{{ colgroup.attributes }}>*/
/*         {% for col in colgroup.cols %}*/
/*           <col{{ col.attributes }} />*/
/*         {% endfor %}*/
/*       </colgroup>*/
/*     {% else %}*/
/*       <colgroup{{ colgroup.attributes }} />*/
/*     {% endif %}*/
/*   {% endfor %}*/
/* */
/*   {% if header %}*/
/*     <thead>*/
/*       <tr>*/
/*         {% for cell in header %}*/
/*         {%*/
/*         set cell_classes = [*/
/*           cell.active_table_sort ? 'active',*/
/*         ]*/
/*         %}*/
/*         <{{ cell.tag }}{{ cell.attributes.addClass(cell_classes) }}>*/
/*         {{- cell.content -}}*/
/*       </{{ cell.tag }}>*/
/*       {% endfor %}*/
/*       </tr>*/
/*     </thead>*/
/*   {% endif %}*/
/* */
/*   {% if rows %}*/
/*     <tbody>*/
/*       {% for row in rows %}*/
/*         {%*/
/*         set row_classes = [*/
/*           not no_striping ? cycle(['odd', 'even'], loop.index0),*/
/*         ]*/
/*         %}*/
/*         <tr{{ row.attributes.addClass(row_classes) }}>*/
/*           {% for cell in row.cells %}*/
/*             <{{ cell.tag }}{{ cell.attributes }}>*/
/*               {{- cell.content -}}*/
/*             </{{ cell.tag }}>*/
/*           {% endfor %}*/
/*         </tr>*/
/*       {% endfor %}*/
/*     </tbody>*/
/*   {% elseif empty %}*/
/*     <tbody>*/
/*       <tr class="odd">*/
/*         <td colspan="{{ header_columns }}" class="empty message">{{ empty }}</td>*/
/*       </tr>*/
/*     </tbody>*/
/*   {% endif %}*/
/*   {% if footer %}*/
/*     <tfoot>*/
/*       {% for row in footer %}*/
/*         <tr{{ row.attributes }}>*/
/*           {% for cell in row.cells %}*/
/*             <{{ cell.tag }}{{ cell.attributes }}>*/
/*               {{- cell.content -}}*/
/*             </{{ cell.tag }}>*/
/*           {% endfor %}*/
/*         </tr>*/
/*       {% endfor %}*/
/*     </tfoot>*/
/*   {% endif %}*/
/* </table>*/
/* {% if responsive %}*/
/*   </div>*/
/* {% endif %}*/
/* */
