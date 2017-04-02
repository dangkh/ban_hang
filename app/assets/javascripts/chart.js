$(document).on('ready page:load', function() {
  if ($("#hcontainer").length > 0){
    var data_chart = $("#hcontainer").data("chart");
    Highcharts.chart('hcontainer', {
      chart: {
        type: 'column'
      },
      title: {
        text: 'Number product ordered by month'
      },
      yAxis: {
        min: 0,
        title: {
          text: 'order'
        }
      },
      plotOptions: {
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      },
      series: [{
        name: 'product',
        colorByPoint: true,
        data: data_chart,
        dataLabels: {
          enabled: true,
          color: '#FFFFFF',
          align: 'center',
          format: '{point.y:.1f}',
          style: {
            fontSize: '16px',
            fontFamily: 'Verdana, sans-serif'
          }
        }
      }]
    });
    var data_chart1 = $("#hhcontainer").data("chart");
    Highcharts.chart('hhcontainer', {
    chart: {
        type: 'column'
    },
    title: {
        text: 'Number of category by order'
    },
    xAxis: {
        type: 'category'
    },
    yAxis: {
        title: {
            text: 'Total number'
        }

    },
    legend: {
        enabled: false
    },
    series: [{
        name: 'Brands',
        colorByPoint: true,
        data: data_chart1,
    }],
});
  }
})
