//
//  KeepCombinedChartData.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

open class KeepCombinedChartData: KeepBarLineScatterCandleBubbleChartData
{
    private var _lineData: KeepLineChartData!
    private var _barData: KeepBarChartData!
    private var _scatterData: KeepScatterChartData!
    private var _candleData: KeepCandleChartData!
    private var _bubbleData: KeepBubbleChartData!
    
    public override init()
    {
        super.init()
    }
    
    public override init(dataSets: [KeepIChartDataSet]?)
    {
        super.init(dataSets: dataSets)
    }
    
    @objc open var lineData: KeepLineChartData!
    {
        get
        {
            return _lineData
        }
        set
        {
            _lineData = newValue
            notifyDataChanged()
        }
    }
    
    @objc open var barData: KeepBarChartData!
    {
        get
        {
            return _barData
        }
        set
        {
            _barData = newValue
            notifyDataChanged()
        }
    }
    
    @objc open var scatterData: KeepScatterChartData!
    {
        get
        {
            return _scatterData
        }
        set
        {
            _scatterData = newValue
            notifyDataChanged()
        }
    }
    
    @objc open var candleData: KeepCandleChartData!
    {
        get
        {
            return _candleData
        }
        set
        {
            _candleData = newValue
            notifyDataChanged()
        }
    }
    
    @objc open var bubbleData: KeepBubbleChartData!
    {
        get
        {
            return _bubbleData
        }
        set
        {
            _bubbleData = newValue
            notifyDataChanged()
        }
    }
    
    open override func calcMinMax()
    {
        _dataSets.removeAll()
        
        _yMax = -Double.greatestFiniteMagnitude
        _yMin = Double.greatestFiniteMagnitude
        _xMax = -Double.greatestFiniteMagnitude
        _xMin = Double.greatestFiniteMagnitude
        
        _leftAxisMax = -Double.greatestFiniteMagnitude
        _leftAxisMin = Double.greatestFiniteMagnitude
        _rightAxisMax = -Double.greatestFiniteMagnitude
        _rightAxisMin = Double.greatestFiniteMagnitude
        
        let allData = self.allData
        
        for data in allData
        {
            data.calcMinMax()
            
            let sets = data.dataSets
            _dataSets.append(contentsOf: sets)
            
            if data.yMax > _yMax
            {
                _yMax = data.yMax
            }
            
            if data.yMin < _yMin
            {
                _yMin = data.yMin
            }
            
            if data.xMax > _xMax
            {
                _xMax = data.xMax
            }
            
            if data.xMin < _xMin
            {
                _xMin = data.xMin
            }

            for dataset in sets
            {
                if dataset.axisDependency == .left
                {
                    if dataset.yMax > _leftAxisMax
                    {
                        _leftAxisMax = dataset.yMax
                    }
                    if dataset.yMin < _leftAxisMin
                    {
                        _leftAxisMin = dataset.yMin
                    }
                }
                else
                {
                    if dataset.yMax > _rightAxisMax
                    {
                        _rightAxisMax = dataset.yMax
                    }
                    if dataset.yMin < _rightAxisMin
                    {
                        _rightAxisMin = dataset.yMin
                    }
                }
            }
        }
    }
    
    /// - returns: All data objects in row: line-bar-scatter-candle-bubble if not null.
    @objc open var allData: [KeepChartData]
    {
        var data = [KeepChartData]()
        
        if lineData !== nil
        {
            data.append(lineData)
        }
        if barData !== nil
        {
            data.append(barData)
        }
        if scatterData !== nil
        {
            data.append(scatterData)
        }
        if candleData !== nil
        {
            data.append(candleData)
        }
        if bubbleData !== nil
        {
            data.append(bubbleData)
        }
        
        return data
    }
    
    @objc open func dataByIndex(_ index: Int) -> KeepChartData
    {
        return allData[index]
    }
    
    open func dataIndex(_ data: KeepChartData) -> Int?
    {
        return allData.index(of: data)
    }
    
    open override func removeDataSet(_ dataSet: KeepIChartDataSet!) -> Bool
    {
        let datas = allData
        
        var success = false
        
        for data in datas
        {
            success = data.removeDataSet(dataSet)
            
            if success
            {
                break
            }
        }
        
        return success
    }
    
    open override func removeDataSetByIndex(_ index: Int) -> Bool
    {
        print("removeDataSet(index) not supported for CombinedData", terminator: "\n")
        return false
    }
    
    open override func removeEntry(_ entry: KeepChartDataEntry, dataSetIndex: Int) -> Bool
    {
        print("removeEntry(entry, dataSetIndex) not supported for CombinedData", terminator: "\n")
        return false
    }
    
    open override func removeEntry(xValue: Double, dataSetIndex: Int) -> Bool
    {
        print("removeEntry(xValue, dataSetIndex) not supported for CombinedData", terminator: "\n")
        return false
    }
    
    open override func notifyDataChanged()
    {
        if _lineData !== nil
        {
            _lineData.notifyDataChanged()
        }
        if _barData !== nil
        {
            _barData.notifyDataChanged()
        }
        if _scatterData !== nil
        {
            _scatterData.notifyDataChanged()
        }
        if _candleData !== nil
        {
            _candleData.notifyDataChanged()
        }
        if _bubbleData !== nil
        {
            _bubbleData.notifyDataChanged()
        }
        
        super.notifyDataChanged() // recalculate everything
    }
    
    /// Get the Entry for a corresponding highlight object
    ///
    /// - parameter highlight:
    /// - returns: The entry that is highlighted
    open override func entryForHighlight(_ highlight: KeepHighlight) -> KeepChartDataEntry?
    {
        if highlight.dataIndex >= allData.count
        {
            return nil
        }
        
        let data = dataByIndex(highlight.dataIndex)
        
        if highlight.dataSetIndex >= data.dataSetCount
        {
            return nil
        }
        
        // The value of the highlighted entry could be NaN - if we are not interested in highlighting a specific value.
        let entries = data.getDataSetByIndex(highlight.dataSetIndex).entriesForXValue(highlight.x)
        for e in entries
        {
            if e.y == highlight.y || highlight.y.isNaN
            {
                return e
            }
        }
        return nil
    }
    
    /// Get dataset for highlight
    ///
    /// - Parameter highlight: current highlight
    /// - Returns: dataset related to highlight
    @objc open func getDataSetByHighlight(_ highlight: KeepHighlight) -> KeepIChartDataSet!
    {  
        if highlight.dataIndex >= allData.count
        {
            return nil
        }
        
        let data = dataByIndex(highlight.dataIndex)
        
        if highlight.dataSetIndex >= data.dataSetCount
        {
            return nil
        }
        
        return data.dataSets[highlight.dataSetIndex]
    }
}
