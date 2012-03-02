
window.fr = window.fr || {};
var fr = window.fr;

$(".date-value").change(function() {
  $('.export-button').addClass('hidden');
});

fr.summary_registrations_report = function(target) {
  var options = {
   chart: {
      renderTo: 'registrations',
      type: 'column'
   },
   title: {},
   xAxis: { 
    categories: [] 
   },
   yAxis: {
      min: 0,
      title: {}
   },
   tooltip: {
      formatter: function() {
        var s;
        if (this.point.name) { // the pie chart
          s = ''+ this.point.name +': '+ this.y;
        } else {
          s = ''+ this.series.name  +': '+ this.y;
        }
        return s;
      }
    },
  };

  $.getJSON(summaryregistrationsEndpoint, function(data) {
    options.title.text = data.title;
    options.xAxis.categories = data.categories;
    options.yAxis.title.text = data.axis.y;
    options.series = [];
    $.each(data.series, function(k, v) {
      var series;
      if(k == 'summary') {
        series = {
          type: 'spline',
          name: v.name,
          data: v.avg,
        }; 
      } else {
        series = {
          type: 'column',
          name: v.name,
          data: v.counts
        };  
      };
      options.series.push(series);
    });

    var registrations = new Highcharts.Chart(options);  
  });
};

fr.summary_subscriber_growth_report = function(target) {
  var options = {
    chart: {
      renderTo: target,
      type: 'area'
    },
    title: {},
    xAxis: {
      labels: {
        formatter: function() {
          return this.value; // clean, unformatted number for year
        }
      }
    },
    yAxis: {
      title: {},
      labels: {
        formatter: function() {
          return this.value;
        }
      }
    },
    plotOptions: {
      area: {
        stacking: 'normal',
        marker: {
          enabled: false,
          symbol: 'circle',
          radius: 2,
          states: {
            hover: {
              enabled: true
            }
          }
        }
      }
    }
  }

  $.getJSON(summarysubscribergrowthEndpoint, function(data) {
    options.title.text = data.title;
    options.xAxis.categories = data.categories;
    options.yAxis.title.text = data.axis.y;
    options.series = [];
    $.each(data.series, function(k, v) {
      var series = {
        name: v.name,
        data: v.counts
      };  
      options.series.push(series);
    });

    fedreg.hidelocalspinner(target);
    var growth = new Highcharts.Chart(options);
  });  
};

fr.summary_sessions_report = function(target) {
  var options = {
    chart: {
      renderTo: 'sessions',
      type: 'area'
    },
    title: {},
    xAxis: {
      labels: {
        formatter: function() {
          return this.value; // clean, unformatted number for year
        }
      }
    },
    yAxis: {
      title: {},
      labels: {
        formatter: function() {
          return this.value;
        }
      }
    },
    plotOptions: {
      area: {
        marker: {
          enabled: false,
          symbol: 'circle',
          radius: 2,
          states: {
            hover: {
              enabled: true
            }
          }
        }
      }
    }
  }

  $.getJSON(summarysessionsEndpoint, function(data) {
    options.title.text = data.title;
    options.xAxis.categories = data.categories;
    options.yAxis.title.text = data.axis.y;
    options.series = [];
    var series = {
      name: data.series.name,
      data: data.series.count
    };  
    options.series.push(series);

    var sessions = new Highcharts.Chart(options);
  });  
};

var detailedregistrations;
$(".export-detailed-registration-report").click(function() {
  var form = $('#detailed-registration-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    window.location = detailedregistrationsEndpoint + '?type=csv&' + params
  }
});
$(".request-detailed-registration-report").click(function () {
  var form = $('#detailed-registration-report-parameters');
  if(form.valid()) { 
    var exportBut = $('.export-detailed-registration-report');
    var registrationDetails = $("#registrationdetails");
    var organizationregistrations = $("#organizationregistrations");
    var idpregistrations = $("#idpregistrations");
    var spregistrations = $("#spregistrations");

    if(detailedregistrations) {
      detailedregistrations.destroy();
    }

    registrationDetails.addClass('hidden');
    organizationregistrations.html('');
    idpregistrations.html('');
    spregistrations.html('');
    fedreg.showspinner();

    var options = {
      chart: {
        renderTo: 'detailedregistrationschart',
        type: 'area',
        height: 600,
        zoomType: 'x',
      },
      title: {},
      xAxis: {
        type: 'datetime',
        maxZoom: 14 * 24 * 3600000, // fourteen days
        title: {
          text: null
        }
      },
      yAxis: {
        title: {},
        labels: {
          formatter: function() {
            return this.value;
          }
        }
      },
      plotOptions: {
        area: {
          marker: {
            enabled: false,
            symbol: 'circle',
            radius: 2,
            states: {
              hover: {
                enabled: true
              }
            }
          }
        }
      }
    }

    var params = form.serialize();
    $.getJSON(detailedregistrationsEndpoint, params, function(data) {
      options.title.text = data.title;
      options.yAxis.title.text = data.axis.y;
      options.series = [];
      $.each(data.series, function(k, v) {
        var series = {
          type: 'area',
          pointInterval: 24 * 3600 * 1000,
          pointStart: Date.UTC(data.startdate.year, data.startdate.month, data.startdate.day),
          name: v.name,
          data: v.counts
        };  
        options.series.push(series);
      });

      $.each(data.detail.org, function(k,v) {
        organizationregistrations.append("<tr><td>"+v.displayName+"</td><td>"+v.dateCreated+"</td><td><a href='"+v.url+"' class='btn'>view</td></tr>");
      });

      $.each(data.detail.idp, function(k,v) {
        idpregistrations.append("<tr><td>"+v.displayName+"</td><td>"+v.dateCreated+"</td><td><a href='"+v.url+"' class='btn'>view</td></tr>");
      });

      $.each(data.detail.sp, function(k,v) {
        spregistrations.append("<tr><td>"+v.displayName+"</td><td>"+v.dateCreated+"</td><td><a href='"+v.url+"' class='btn'>view</td></tr>");
      });

      fedreg.hidespinner();
      detailedregistrations = new Highcharts.Chart(options);
      registrationDetails.removeClass('hidden');
      exportBut.removeClass('hidden');
    });
  }
});

var detailedsubscribergrowth;
$(".export-detailed-growth-report").click(function() {
  var form = $('#detailed-growth-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    window.location = detailedgrowthEndpoint + '?type=csv&' + params
  }
});
$(".request-detailed-growth-report").click(function () {
  var form = $('#detailed-growth-report-parameters');
  if(form.valid()) { 
    var exportBut = $('.export-detailed-growth-report');
    if(detailedsubscribergrowth)
      detailedsubscribergrowth.destroy();

    fedreg.showspinner();

    var options = {
      chart: {
        renderTo: 'detailedgrowthchart',
        type: 'area',
        height: 600,
        zoomType: 'x',
      },
      title: {},
      xAxis: {
        type: 'datetime',
        maxZoom: 14 * 24 * 3600000, // fourteen days
        title: {
          text: null
        }
      },
      yAxis: {
        title: {},
        labels: {
          formatter: function() {
            return this.value;
          }
        }
      },
      plotOptions: {
        area: {
          stacking: 'normal',
          marker: {
            enabled: false,
            symbol: 'circle',
            radius: 2,
            states: {
              hover: {
                enabled: true
              }
            }
          }
        }
      }
    }

    var params = form.serialize();
    $.getJSON(detailedgrowthEndpoint, params, function(data) {
      options.title.text = data.title;
      options.yAxis.title.text = data.axis.y;
      options.series = [];
      $.each(data.series, function(k, v) {
        var series = {
          type: 'area',
          pointInterval: 24 * 3600 * 1000,
          pointStart: Date.UTC(data.startdate.year, data.startdate.month, data.startdate.day),
          name: v.name,
          data: v.counts
        };  
        options.series.push(series);
      });

      fedreg.hidespinner();
      detailedsubscribergrowth = new Highcharts.Chart(options);
      exportBut.removeClass('hidden');
    });
  }
});

var detailedsessions;
$(".export-detailed-sessions-report").click(function() {
  var form = $('#detailed-sessions-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    window.location = detailedsessionsEndpoint + '?type=csv&' + params
  }
});
$(".request-detailed-sessions-report").click(function () {
  var form = $('#detailed-sessions-report-parameters');
  if(form.valid()) {
    var exportBut = $('.export-detailed-sessions-report');
    if(detailedsessions) {
      detailedsessions.destroy();
    }
    fedreg.showspinner();

    var options = {
      chart: {
        renderTo: 'detailedsessionschart',
        type: 'area',
        height: 600,
        zoomType: 'x',
      },
      title: {},
      xAxis: {
        type: 'datetime',
        maxZoom: 14 * 24 * 3600000, // fourteen days
        title: {
          text: null
        }
      },
      yAxis: {
        title: {},
        labels: {
          formatter: function() {
            return this.value;
          }
        }
      },
      plotOptions: {
        area: {
          marker: {
            enabled: false,
            symbol: 'circle',
            radius: 2,
            states: {
              hover: {
                enabled: true
              }
            }
          }
        }
      }
    }

    var params = form.serialize();
    $.getJSON(detailedsessionsEndpoint, params, function(data) {
      options.title.text = data.title;
      options.yAxis.title.text = data.axis.y;
      options.series = [];
      var series = {
        type: 'area',
        pointInterval: 24 * 3600 * 1000,
        pointStart: Date.UTC(data.startdate.year, data.startdate.month, data.startdate.day),
        name: data.series.overall.name,
        data: data.series.overall.count
      };  
      options.series.push(series);


      fedreg.hidespinner();
      detailedsessions = new Highcharts.Chart(options);
      exportBut.removeClass('hidden');
    });
  }  
});

$(".select-all-topten-services").click(function () {
  $('#topten-utilized-services :unchecked').attr('checked', true);
  return false;
});

$(".unselect-all-topten-services").click(function () {
  $('#topten-utilized-services :checked').attr('checked', false);
  return false;
});

$(".select-all-remaining-services").click(function () {
  $('#remaning-utilized-services :unchecked').attr('checked', true);
  return false;
});

$(".unselect-all-remaining-services").click(function () {
  $('#remaning-utilized-services :checked').attr('checked', false);
  return false;
});

$(".request-refine-detailedserviceutilization-content").click(function () {
  fedreg.set_button($(this));
  var form = $('#detailed-detailedserviceutilization-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    params = params + '&' + $('#refine-detailedserviceutilization-report-parameters').serialize();
    requestServiceUtilization(params);
  }
  fedreg.reset_button($(this));
});

$(".request-detailed-detailedserviceutilization-reports").click(function () {
  var form = $('#detailed-detailedserviceutilization-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    requestServiceUtilization(params);
  }
});

$(".export-detailed-detailedserviceutilization-reports").click(function() {
  var form = $('#detailed-detailedserviceutilization-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    params = params + '&' + $('#refine-detailedserviceutilization-report-parameters').serialize();
    window.location = detailedserviceutilizationEndpoint + '?type=csv&' + params
  }
});

var serviceutilization;
var serviceutilizationtotals;
function requestServiceUtilization(params) {
    var refineContent = $("#refine-detailedserviceutilization-content");
    var topTenContent = $('#refine-detailedserviceutilization-report-parameters > .topten');
    var remainderContent = $('#refine-detailedserviceutilization-report-parameters > .remainder');
    var topTen = $('#topten-utilized-services');
    var remainder = $('#remaning-utilized-services');
    var exportBut = $('.export-detailed-detailedserviceutilization-reports');

    if(serviceutilization) {
      serviceutilization.destroy();
      serviceutilizationtotals.destroy();
    }

    refineContent.addClass('hidden');
    topTenContent.addClass('hidden');
    remainderContent.addClass('hidden');
    exportBut.addClass('hidden');
    topTen.html('');
    remainder.html(''); 
    fedreg.showspinner();

    var options = {
      chart: {
        renderTo: 'detailedserviceutilization',
        defaultSeriesType: 'bar',
        height: 40
      },
      title: {},
      xAxis: {
        categories: [],
        title: {
          enabled:false
        },
      },
      yAxis: {
        min: 0,
        title: {
          text: '',
        }
      },
      legend: {
        enabled: false,
      },
      plotOptions: {
        bar: {
          dataLabels: {
              enabled: true,
              y:-5,
              color:"black",
              style: {
                  fontSize: "12px"
              },
              formatter: function(){
                return this.name;
              }
          }
        }
      }
    }

    var options2 = {
      chart: {
        renderTo: 'detailedserviceutilizationtotals',
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        height: 440
      },
      title: {
        text: ''
      },
      tooltip: {
        formatter: function() {
          return '<b>'+ this.point.name +'</b>: '+ this.y + ' sessions ('+this.percentage +' %)';
        }
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: false
          },
          showInLegend: false
        }
      },
      series: []
    }

    $.getJSON(detailedserviceutilizationEndpoint, params, function(data) {
      options.title.text = data.title;
      options.yAxis.title.text = data.axis.y;
      options.series = [];
      var series = {
        name: 'Sessions',
        data: [],
        showInLegend: true
      };
      
      if(data.series.length > 0) {
        topTenContent.removeClass('hidden');
        refineContent.removeClass('hidden');
        exportBut.removeClass('hidden');
      }
      else {
        topTenContent.addClass('hidden');
        refineContent.addClass('hidden');
        exportBut.addClass('hidden');
      }

      if(data.series.length > 10)
        remainderContent.removeClass('hidden');
      else
        remainderContent.addClass('hidden');

      var totals = {
        type: 'pie',
        name: 'Session Totals',
        size: 400,
        data: []
      };

      $.each(data.series, function(k, v) {
        if(!v.excluded) {
          options.chart.height = options.chart.height + 40 // allow room per rendered sp
          options.xAxis.categories.push(v.name);
          series.data.push(v.count);

          var data = {
            name: v.name,
            y: v.count
          };
          totals.data.push(data);

          var markup = '<label class="span3"><input name="activesp" type="checkbox" checked="checked" value="'+v.id+'"/> ' + v.name + '</label>';
        }
        else
          var markup = '<label class="span3"><input name="activesp" type="checkbox" value="'+v.id+'"/> ' + v.name + '</label>';

        if(k < 10)
          topTen.append(markup);
        else
          remainder.append(markup);
      });

      options.series.push(series); 
      options2.series.push(totals);
      
      fedreg.hidespinner();
      serviceutilization = new Highcharts.Chart(options);
      serviceutilizationtotals = new Highcharts.Chart(options2);
    });
};

$(".select-all-topten-idps").click(function () {
  $('#topten-utilized-idps :unchecked').attr('checked', true);
  return false;
});

$(".unselect-all-topten-idps").click(function () {
  $('#topten-utilized-idps :checked').attr('checked', false);
  return false;
});

$(".select-all-remaining-idps").click(function () {
  $('#remaning-utilized-idps :unchecked').attr('checked', true);
  return false;
});

$(".unselect-all-remaining-idps").click(function () {
  $('#remaning-utilized-idps :checked').attr('checked', false);
  return false;
});

$(".request-refine-detailedidputilization-content").click(function () {
  fedreg.set_button($(this));
  var form = $('#detailed-detailedidputilization-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    params = params + '&' + $('#refine-detailedidputilization-report-parameters').serialize();
    requestIdPUtilization(params);
  }
  fedreg.reset_button($(this));
});

$(".request-detailed-detailedidputilization-reports").click(function () {
  var form = $('#detailed-detailedidputilization-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    requestIdPUtilization(params);
  }
});

$(".export-detailed-detailedidputilization-reports").click(function() {
  var form = $('#detailed-detailedidputilization-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    params = params + '&' + $('#refine-detailedidputilization-report-parameters').serialize();
    window.location = detailedidputilizationEndpoint + '?type=csv&' + params
  }
});

var idputilization;
var idputilizationtotals;
function requestIdPUtilization(params) {
    var refineContent = $("#refine-detailedidputilization-content");
    var topTenContent = $('#refine-detailedidputilization-report-parameters > .topten');
    var remainderContent = $('#refine-detailedidputilization-report-parameters > .remainder');
    var topTen = $('#topten-utilized-idps');
    var remainder = $('#remaning-utilized-idps');
    var exportBut = $('.export-detailed-detailedidputilization-reports');

    if(idputilization) {
      idputilization.destroy();
      idputilizationtotals.destroy();
    }

    refineContent.addClass('hidden');
    topTenContent.addClass('hidden');
    remainderContent.addClass('hidden');
    exportBut.addClass('hidden');
    topTen.html('');
    remainder.html(''); 
    fedreg.showspinner();

    var options = {
      chart: {
        renderTo: 'detailedidputilization',
        defaultSeriesType: 'bar',
        height: 40
      },
      title: {},
      xAxis: {
        categories: [],
        title: {
          enabled:false
        },
      },
      yAxis: {
        min: 0,
        title: {
          text: '',
        }
      },
      legend: {
        enabled: false,
      },
      plotOptions: {
        bar: {
          dataLabels: {
              enabled: true,
              y:-5,
              color:"black",
              style: {
                  fontSize: "12px"
              },
              formatter: function(){
                return this.name;
              }
          }
        }
      }
    }

    var options2 = {
      chart: {
        renderTo: 'detailedidputilizationtotals',
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        height: 440
      },
      title: {
        text: ''
      },
      tooltip: {
        formatter: function() {
          return '<b>'+ this.point.name +'</b>: '+ this.y + ' sessions ('+this.percentage +' %)';
        }
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: false
          },
          showInLegend: false
        }
      },
      series: []
    }

    $.getJSON(detailedidputilizationEndpoint, params, function(data) {
      options.title.text = data.title;
      options.yAxis.title.text = data.axis.y;
      options.series = [];
      var series = {
        name: 'Sessions',
        data: [],
        showInLegend: true
      };
      
      if(data.series.length > 0) {
        topTenContent.removeClass('hidden');
        refineContent.removeClass('hidden');
        exportBut.removeClass('hidden');
      }
      else {
        topTenContent.addClass('hidden');
        refineContent.removeClass('hidden');
      }

      if(data.series.length > 10)
        remainderContent.removeClass('hidden');
      else
        remainderContent.addClass('hidden');

      var totals = {
        type: 'pie',
        name: 'Session Totals',
        size: 400,
        data: []
      };

      $.each(data.series, function(k, v) {
        if(!v.excluded) {
          options.chart.height = options.chart.height + 40 // allow room per rendered sp
          options.xAxis.categories.push(v.name);
          series.data.push(v.count);

          var data = {
            name: v.name,
            y: v.count
          };
          totals.data.push(data);

          var markup = '<label class="span3"><input name="activeidp" type="checkbox" checked="checked" value="'+v.id+'"/> ' + v.name + '</label>';
        }
        else
          var markup = '<label class="span3"><input name="activeidp" type="checkbox" value="'+v.id+'"/> ' + v.name + '</label>';

        if(k < 10)
          topTen.append(markup);
        else
          remainder.append(markup);
      });

      options.series.push(series); 
      options2.series.push(totals);
      
      fedreg.hidespinner();
      idputilization = new Highcharts.Chart(options);
      idputilizationtotals = new Highcharts.Chart(options2);
    });
};

var detaileddemand;
$(".export-detailed-demand-report").click(function() {
  var form = $('#detailed-demand-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    window.location = detaileddemandEndpoint + '?type=csv&' + params
  }
});

$(".request-detailed-demand-report").click(function () {
  var form = $('#detailed-demand-report-parameters');
  if(form.valid()) {

    var exportBut = $('.export-detailed-demand-report');
    if(detaileddemand) {
      detaileddemand.destroy();
    }
    fedreg.showspinner();

    var options = {
      chart: {
        renderTo: 'demanddetailed',
        type: 'area',
        height: 600,
      },
      title: {},
      xAxis: {
        type: 'linear',
        title: {
          text: 'Hour in day (24 hr format)'
        },
        tickInterval: 1
      },
      yAxis: {
        title: {},
        labels: {
          formatter: function() {
            return this.value;
          }
        }
      },
      legend: {
        enabled: false,
      },
      plotOptions: {
        area: {
          marker: {
            enabled: false,
            symbol: 'circle',
            radius: 2,
            states: {
              hover: {
                enabled: true
              }
            }
          }
        }
      }
    }

    var params = form.serialize();
    $.getJSON(detaileddemandEndpoint, params, function(data) {
      options.title.text = data.title;
      options.yAxis.title.text = data.axis.y;
      options.series = [];
      var series = {
        type: 'area',
        name: 'sessions',
        color: '#3BA187',
        data: data.series
      };  
      options.series.push(series);


      fedreg.hidespinner();
      exportBut.removeClass('hidden');
      detaileddemand = new Highcharts.Chart(options);
    });
  }  
});

var dsutilizationaccesses;
var dsutilizationtotals;
$(".export-detailed-dsutilization-report").click(function() {
  var form = $('#detailed-dsutilization-report-parameters');
  if(form.valid()) { 
    var params = form.serialize();
    window.location = detailedwayfnodesessionsEndpoint + '?type=csv&' + params
  }
});
$(".request-detailed-dsutilization-reports").click(function () {
  var form = $('#detailed-dsutilization-report-parameters');
  if(form.valid()) { 
    var exportBut = $('.export-detailed-dsutilization-report');
    if(dsutilizationaccesses) {
      dsutilizationaccesses.destroy();
      dsutilizationtotals.destroy();
    }
    fedreg.showspinner();

    var options2 = {
      chart: {
        renderTo: 'detailedwayfnodesessions',
        type: 'area',
        height: 600,
        zoomType: 'x',
      },
      title: {},
      xAxis: {
        type: 'datetime',
        maxZoom: 14 * 24 * 3600000, // fourteen days
        title: {
          text: null
        }
      },
      yAxis: {
        title: {},
        labels: {
          formatter: function() {
            return this.value;
          }
        }
      },
      plotOptions: {
        area: {
          marker: {
            enabled: false,
            symbol: 'circle',
            radius: 2,
            states: {
              hover: {
                enabled: true
              }
            }
          }
        }
      }
    }

    var options3 = {
      chart: {
        renderTo: 'detailedwayfnodesessionstotals',
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: true,
        height: 460,
      },
      title: {
        text: ''
      },
      tooltip: {
        formatter: function() {
          return '<b>'+ this.point.name +'</b>: '+ this.y + ' sessions ('+this.percentage +' %)';
        }
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: false
          },
          showInLegend: true
        }
      },
      series: []
    }

    var params = form.serialize();
    $.getJSON(detaileddsutilizationEndpoint, params, function(data) {
      options2.title.text = data.title;
      options2.yAxis.title.text = data.axis.y;
      options2.series = [];
      $.each(data.series, function(k, v) {
        var series = {
          type: 'area',
          pointInterval: 24 * 3600 * 1000,
          pointStart: Date.UTC(data.startdate.year, data.startdate.month, data.startdate.day),
          name: v.name,
          data: v.counts
        };  
        options2.series.push(series);
      });

      var totals = {
        type: 'pie',
        name: 'Session Totals',
        size: 380,
        data: []
      };
      $.each(data.totals, function(k, v) {
        var data = {
          name: v.name,
          y: v.count
        };
        totals.data.push(data); 
      });
      options3.series.push(totals);

      fedreg.hidespinner();
      dsutilizationaccesses = new Highcharts.Chart(options2);
      dsutilizationtotals = new Highcharts.Chart(options3);
      exportBut.removeClass('hidden');
    });
  }  
});