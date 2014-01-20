package com.refract.prediabetes.stateMachine.VO {
	/**
	 * @author otlabs
	 */
	public class HistoryVO 
	{
		public var state : String ; 
		public var btName : String ; 
		public function HistoryVO( m_btName : String , m_state : String )
		{
			btName = m_btName ;
			state = m_state ;
		}
	}
}
