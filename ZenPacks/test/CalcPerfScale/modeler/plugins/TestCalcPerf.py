from Products.DataCollector.plugins.CollectorPlugin import PythonPlugin
from Products.DataCollector.plugins.DataMaps import RelationshipMap, ObjectMap


class TestCalcPerf(PythonPlugin):
    deviceProperties = PythonPlugin.deviceProperties + (
        'zTestCalcPerfTopComponentsPerDevice',
        'zTestCalcPerfBottomComponentsPerTopComponent',
        )

    def collect(self, device, log):
        return 'IGNORE'

    def process(self, device, results, log):
        maps = []

        top_rm = RelationshipMap(relname='testTopComponents')

        maps.append(top_rm)

        for i in range(device.zTestCalcPerfTopComponentsPerDevice):
            top_rm.append(
                ObjectMap(data={
                    'id': 'top{}'.format(i),
                    },
                    modname='ZenPacks.test.CalcPerfScale.TestTopComponent'))

            bottom_rm = RelationshipMap(
                compname='testTopComponents/top{}'.format(i),
                relname='testBottomComponents')

            for j in range(device.zTestCalcPerfBottomComponentsPerTopComponent):
                bottom_rm.append(
                    ObjectMap(data={
                        'id': 'top{}-bottom{}'.format(i, j),
                        },
                        modname='ZenPacks.test.CalcPerfScale.TestBottomComponent'))

            maps.append(bottom_rm)

        return maps
